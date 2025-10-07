import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/constants/language_manager.dart';
import '../manager/scan_cubit.dart';
import '../manager/scan_state.dart';
import 'widgets/scan_overlay.dart';
import 'widgets/scan_result_dialog.dart';
import 'widgets/scan_product_card.dart';

class ScanView extends StatelessWidget {
  const ScanView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScanScreen();
  }
}

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scanLineController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scanLineAnimation;

  MobileScannerController? _scannerController;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeScanner();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scanLineController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scanLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanLineController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
    _scanLineController.repeat();
  }

  void _initializeScanner() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {
        _scannerController = MobileScannerController();
        _isScanning = true;
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scanLineController.dispose();
    _scannerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageManager = Provider.of<LanguageManager>(context);
    final isArabic = languageManager.isArabic;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: BlocProvider(
        create: (context) => ScanCubit(),
        child: BlocConsumer<ScanCubit, ScanState>(
          listener: (context, state) {
            print('🔍 ScanView - State changed: ${state.runtimeType}');

            if (state is ScanSuccess) {
              print('🔍 ScanView - ScanSuccess detected');
              _showScanResult(context, state.result, isArabic);
            } else if (state is ScanError) {
              print('🔍 ScanView - ScanError detected: ${state.message}');
              _showError(context, state.message, isArabic);
            } else if (state is ProductScanned) {
              print(
                '🔍 ScanView - ProductScanned detected: ${state.productName}',
              );
              // لا نحتاج لعمل شيء هنا، البطاقة ستظهر تلقائياً
            } else if (state is ScanCountdown) {
              print('🔍 ScanView - ScanCountdown detected: ${state.countdown}');
            } else if (state is ScanLoading) {
              print('🔍 ScanView - ScanLoading detected');
            } else if (state is ScanInitial) {
              print('🔍 ScanView - ScanInitial detected');
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                // الكاميرا
                _buildCameraView(),

                // طبقة التحكم
                _buildControlLayer(context, isArabic),

                // طبقة المسح
                _buildScanOverlay(),

                // مؤشر التحميل
                if (state is ScanLoading) _buildLoadingIndicator(isArabic),

                // مؤشر العد التنازلي
                if (state is ScanCountdown)
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 100,
                    left: 0,
                    right: 0,
                    child: _buildCountdownIndicator(state.countdown, isArabic),
                  ),

                // بطاقة المنتج الممسوح
                if (state is ProductScanned)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ScanProductCard(
                      productName: state.productName,
                      productCategory: state.productCategory,
                      productImage: state.productImage,
                      productId: state.productId,
                      productPrice: state.productPrice,
                      onAddPressed: () {
                        context.go(
                          '/product-details2',
                          extra: {
                            'productName': state.productName,
                            'productCategory': state.productCategory,
                            'productImage': state.productImage,
                          },
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCameraView() {
    if (_scannerController == null || !_isScanning) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 80,
                color: Colors.white.withOpacity(0.5),
              ),
              const SizedBox(height: 20),
              Text(
                'Camera not available',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return AbsorbPointer(
      absorbing: false, // السماح للمسح بالعمل
      child: MobileScanner(
        controller: _scannerController!,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final barcode = barcodes.first;
            if (barcode.rawValue != null) {
              context.read<ScanCubit>().processProductScan(barcode.rawValue!);
            }
          }
        },
      ),
    );
  }

  Widget _buildControlLayer(BuildContext context, bool isArabic) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        child: Column(
          children: [
            // شريط علوي
            _buildTopBar(context, isArabic),

            const Spacer(),

            // شريط سفلي
            _buildBottomBar(context, isArabic),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Spacer(),

          // زر الفلاش
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _scannerController?.toggleTorch();
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.flash_on,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // نص التعليمات
          Text(
            isArabic
                ? 'وجه الكاميرا نحو رمز QR أو الباركود'
                : 'Point camera at QR code or barcode',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildScanOverlay() {
    return ScanOverlay(
      pulseAnimation: _pulseAnimation,
      scanLineAnimation: _scanLineAnimation,
    );
  }

  Widget _buildCountdownIndicator(int countdown, bool isArabic) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.timer, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              isArabic
                  ? 'سيظهر منتج خلال $countdown ثانية...'
                  : 'Product will appear in $countdown seconds...',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(bool isArabic) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              isArabic ? 'جاري المعالجة...' : 'Processing...',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showScanResult(BuildContext context, String result, bool isArabic) {
    showDialog(
      context: context,
      builder: (context) =>
          ScanResultDialog(result: result, isArabic: isArabic),
    );
  }

  void _showError(BuildContext context, String message, bool isArabic) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
