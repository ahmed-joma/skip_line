import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/invoice_data_storage.dart';

class PaymentSuccessView extends StatefulWidget {
  final double totalAmount;
  final String currency;
  final int? orderId;
  final List<dynamic>? cartItems; // إضافة بيانات السلة

  const PaymentSuccessView({
    Key? key,
    required this.totalAmount,
    required this.currency,
    this.orderId,
    this.cartItems, // إضافة المعامل الجديد
  }) : super(key: key);

  @override
  State<PaymentSuccessView> createState() => _PaymentSuccessViewState();
}

class _PaymentSuccessViewState extends State<PaymentSuccessView> {
  @override
  void initState() {
    super.initState();
    // Payment completed successfully
    print('Payment completed successfully - User remains logged in');
    print('🎉 PaymentSuccessView - Total Amount: ${widget.totalAmount}');
    print('🎉 PaymentSuccessView - Order ID: ${widget.orderId}');
    print(
      '🎉 PaymentSuccessView - Cart Items Count: ${widget.cartItems?.length ?? 0}',
    );
    print('🎉 PaymentSuccessView - Cart Items: ${widget.cartItems}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Back button
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        context.pop();
                      } else {
                        context.go('/home');
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Main content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Payment success image
                    Image.asset(
                      'assets/images/payment.png',
                      width: 300,
                      height: 300,
                    ),

                    const SizedBox(height: 40),

                    // Success message
                    const Text(
                      'Payment Success, Yayy!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 15),

                    // Description
                    Text(
                      'we will send order details and invoice in your contact no. and registered email',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),

                    // Evaluation link
                    GestureDetector(
                      onTap: () {
                        // Handle evaluation
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'evaluation',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey[700],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // QR Code image
                    Image.asset(
                      'assets/images/qrcode.png',
                      width: 80,
                      height: 80,
                    ),

                    const SizedBox(height: 30),

                    // Download Invoice button
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF123459), Color(0xFF0F2A47)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF123459).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () async {
                            // طباعة تشخيصية قبل الانتقال للفاتورة
                            print('📄 Download Invoice Button Pressed');
                            print('📄 Total Amount: ${widget.totalAmount}');
                            print('📄 Order ID: ${widget.orderId}');

                            // جلب البيانات من التخزين المؤقت
                            final invoiceData =
                                InvoiceDataStorage.getInvoiceData();
                            print(
                              '📄 Retrieved Cart Items Count: ${invoiceData['cartItems'].length}',
                            );
                            print(
                              '📄 Retrieved Cart Items: ${invoiceData['cartItems']}',
                            );

                            // Navigate to invoice page with order data
                            context.go(
                              '/invoice',
                              extra: {
                                'totalAmount': widget.totalAmount,
                                'currency': widget.currency,
                                'orderId': widget.orderId,
                              },
                            );
                          },
                          child: const Center(
                            child: Text(
                              'Download Invoice',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Return to home page link
                    GestureDetector(
                      onTap: () {
                        context.go('/home');
                      },
                      child: Text(
                        'Return to the home page',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
