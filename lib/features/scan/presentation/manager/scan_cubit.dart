import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';
import 'dart:async';
import 'scan_state.dart';
import '../../../../core/services/product_service.dart';
import '../../../../core/models/product_model.dart';

class ScanCubit extends Cubit<ScanState> {
  int _countdown = 5;

  ScanCubit() : super(ScanInitial()) {
    // عرض المنتج تلقائياً للاختبار
    _showProductForTesting();
  }

  void _showProductForTesting() {
    // بدء العد التنازلي
    _startCountdown();
  }

  void _startCountdown() {
    _countdown = 5;
    emit(ScanCountdown(countdown: _countdown));

    print('🕐 بدء العد التنازلي للعرض التلقائي...');

    // تحديث العد التنازلي كل ثانية
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _countdown--;
      emit(ScanCountdown(countdown: _countdown));

      if (_countdown <= 0) {
        timer.cancel();
        print('⏰ انتهى العد التنازلي - بدء المسح التلقائي');
        processProductScan('auto_scan');
      }
    });
  }

  void processScanResult(String result) {
    emit(ScanLoading());

    // محاكاة معالجة النتيجة
    Future.delayed(const Duration(milliseconds: 500), () {
      try {
        // التحقق من صحة النتيجة
        if (result.isNotEmpty) {
          emit(ScanSuccess(result: result));
        } else {
          emit(ScanError(message: 'Invalid scan result'));
        }
      } catch (e) {
        emit(ScanError(message: 'Error processing scan result'));
      }
    });
  }

  void resetScan() {
    emit(ScanInitial());
  }

  void setLoading() {
    emit(ScanLoading());
  }

  void setError(String message) {
    emit(ScanError(message: message));
  }

  void processProductScan(String result) async {
    print('🔍 ScanCubit - بدء المسح العشوائي...');
    print('🔍 Input result: $result');

    emit(ScanLoading());
    print('🔍 تم إرسال حالة التحميل');

    try {
      print('🔍 ScanCubit - بدء جلب المنتجات من API...');

      // جلب جميع المنتجات من API
      final apiResult = await ProductService.getProducts();

      print('🔍 ScanCubit - تم استلام النتيجة من API');
      print('🔍 API Success: ${apiResult.isSuccess}');
      print('🔍 API Message: ${apiResult.msg}');
      print('🔍 API Data: ${apiResult.data}');

      if (apiResult.isSuccess && apiResult.data != null) {
        print('✅ تم جلب المنتجات بنجاح من API');

        // دمج Best Sellers و Exclusive Offers في قائمة واحدة
        final allProducts = <ProductModel>[];
        allProducts.addAll(apiResult.data!.bestSellers);
        allProducts.addAll(apiResult.data!.exclusiveOffers);

        print('🔍 إجمالي المنتجات المتاحة: ${allProducts.length}');

        if (allProducts.isNotEmpty) {
          // اختيار منتج عشوائي
          final random = Random();
          final randomProduct = allProducts[random.nextInt(allProducts.length)];

          print('🎲 تم اختيار منتج عشوائي: ${randomProduct.nameAr}');
          print('🎲 Product ID: ${randomProduct.id}');
          print('🎲 Product Price: ${randomProduct.salePrice}');
          print('🎲 Product Image: ${randomProduct.imageUrl}');

          // إضافة تأخير قصير لمحاكاة المسح
          await Future.delayed(const Duration(milliseconds: 800));

          // إرسال المنتج الممسوح
          emit(
            ProductScanned(
              productName: randomProduct.nameAr,
              productCategory: randomProduct.unitAr,
              productImage: randomProduct.imageUrl,
              productId: randomProduct.id,
              productPrice: randomProduct.salePrice,
            ),
          );

          print('✅ تم إرسال المنتج الممسوح: ${randomProduct.nameAr}');
        } else {
          print('❌ لا توجد منتجات متاحة');
          emit(ScanError(message: 'لا توجد منتجات متاحة للمسح'));
        }
      } else {
        print('❌ فشل في جلب المنتجات: ${apiResult.msg}');
        emit(ScanError(message: 'فشل في جلب المنتجات: ${apiResult.msg}'));
      }
    } catch (e) {
      print('❌ خطأ في المسح العشوائي: $e');
      print('❌ Error type: ${e.runtimeType}');
      emit(ScanError(message: 'خطأ في المسح: $e'));
    }
  }

  void clearScannedProduct() {
    emit(ScanInitial());
    // إعادة تشغيل العد التنازلي للمنتج التالي
    print('🔄 إعادة تشغيل العد التنازلي للمنتج التالي...');
    _startCountdown();
  }
}
