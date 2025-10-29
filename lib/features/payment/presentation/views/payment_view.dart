import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../shared/constants/language_manager.dart';
import '../manager/payment_cubit.dart';
import '../manager/payment_state.dart';
import 'widgets/payment_header.dart';
import 'widgets/payment_method_selector.dart';
import 'widgets/credit_card_form.dart';
import 'widgets/payment_button.dart';
import '../../../my_cart/presentation/manager/cart/cart_cubit.dart';
import '../../../my_cart/data/models/cart_item.dart';
import '../../../../core/utils/invoice_data_storage.dart';

class PaymentView extends StatelessWidget {
  final double totalAmount;
  final List<dynamic>? cartItems;

  const PaymentView({Key? key, required this.totalAmount, this.cartItems})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // طباعة السعر للتأكد من استلامه
    print('PaymentView received totalAmount: $totalAmount');

    // التحقق من صحة totalAmount
    final safeTotalAmount =
        totalAmount.isNaN || totalAmount.isInfinite || totalAmount < 0
        ? 0.0
        : totalAmount;

    if (totalAmount != safeTotalAmount) {
      print(
        '⚠️ Invalid totalAmount: $totalAmount, using safe value: $safeTotalAmount',
      );
    }

    return BlocProvider(
      create: (context) => PaymentCubit()..loadPayment(safeTotalAmount),
      child: PaymentViewContent(
        totalAmount: safeTotalAmount,
        cartItems: cartItems,
      ),
    );
  }
}

class PaymentViewContent extends StatefulWidget {
  final double totalAmount;
  final List<dynamic>? cartItems;

  const PaymentViewContent({
    Key? key,
    required this.totalAmount,
    this.cartItems,
  }) : super(key: key);

  @override
  State<PaymentViewContent> createState() => _PaymentViewContentState();
}

class _PaymentViewContentState extends State<PaymentViewContent> {
  final GlobalKey<CreditCardFormState> _creditCardFormKey =
      GlobalKey<CreditCardFormState>();

  @override
  Widget build(BuildContext context) {
    // طباعة تشخيصية عند بناء الصفحة
    print('💳 PaymentView - Building with:');
    print('💳 Total Amount: ${widget.totalAmount}');
    print('💳 Cart Items Count: ${widget.cartItems?.length ?? 0}');
    print('💳 Cart Items: ${widget.cartItems}');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<PaymentCubit, PaymentState>(
          listener: (context, state) {
            if (state is PaymentSuccess) {
              // طباعة تشخيصية للبيانات قبل الانتقال
              print('🚀 Payment Success - Preparing to navigate');
              print('🚀 Total Amount: ${widget.totalAmount}');
              print('🚀 Order ID: ${state.orderId}');
              print('🚀 Cart Items Count: ${widget.cartItems?.length ?? 0}');
              print('🚀 Cart Items: ${widget.cartItems}');

              // حفظ البيانات في التخزين المؤقت
              if (widget.cartItems != null && widget.cartItems!.isNotEmpty) {
                InvoiceDataStorage.saveInvoiceData(
                  cartItems: widget.cartItems!.cast<CartItem>(),
                  totalAmount: widget.totalAmount,
                  currency: 'SAR',
                  orderId: state.orderId ?? 0,
                );
              }

              // Navigate to payment success page
              context.go(
                '/payment-success',
                extra: {
                  'totalAmount': widget.totalAmount,
                  'currency': 'SAR',
                  'orderId': state.orderId,
                },
              );

              // مسح السلة بعد الانتقال (لتجنب التأثير على البيانات المحفوظة)
              Future.delayed(const Duration(milliseconds: 100), () {
                context.read<CartCubit>().clearCart();
              });
            } else if (state is PaymentError) {
              _showErrorDialog(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is PaymentLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with back button and title
                    PaymentHeader(
                      totalAmount: widget.totalAmount,
                      currency: state.payment.currency,
                      vatRate: 15,
                    ),

                    const SizedBox(height: 30),

                    // Payment method selector
                    PaymentMethodSelector(
                      selectedMethod: state.payment.paymentMethod,
                      onMethodChanged: (method) {
                        context.read<PaymentCubit>().updatePaymentMethod(
                          method,
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Credit card form
                    if (state.payment.paymentMethod == 'Credit card')
                      CreditCardForm(
                        key: _creditCardFormKey,
                        payment: state.payment,
                        onCardNumberChanged: (cardNumber) {
                          context.read<PaymentCubit>().updateCardNumber(
                            cardNumber,
                          );
                        },
                        onCardholderChanged: (name) {
                          context.read<PaymentCubit>().updateCardholderName(
                            name,
                          );
                        },
                        onExpiryChanged: (month, year) {
                          context.read<PaymentCubit>().updateExpiryDate(
                            month,
                            year,
                          );
                        },
                        onCVVChanged: (cvv) {
                          context.read<PaymentCubit>().updateCVV(cvv);
                        },
                      ),

                    // Apple Pay section
                    if (state.payment.paymentMethod == 'Apple Pay')
                      _buildApplePaySection(context, widget.totalAmount),

                    const SizedBox(height: 15),

                    // Order details message
                    Center(
                      child: Text(
                        'We will send you an order details to your email after the successful payment',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 35),

                    // Payment button
                    PaymentButton(
                      totalAmount: widget.totalAmount,
                      currency: state.payment.currency,
                      onPressed: () {
                        _validateAndProcessPayment(
                          context,
                          state.payment,
                          widget.cartItems ?? [],
                        );
                      },
                    ),
                  ],
                ),
              );
            } else if (state is PaymentProcessing) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      'Processing payment...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    final languageManager = Provider.of<LanguageManager>(
      context,
      listen: false,
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 30),
            const SizedBox(width: 10),
            Text(languageManager.isArabic ? 'فشل الدفع' : 'Payment Failed'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(languageManager.isArabic ? 'موافق' : 'OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildApplePaySection(BuildContext context, double totalAmount) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          // Apple Pay Logo
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.apple, color: Colors.white, size: 40),
          ),

          const SizedBox(height: 20),

          // Apple Pay Title
          const Text(
            'Apple Pay',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          // Apple Pay Description
          Text(
            'Pay securely with Touch ID or Face ID',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 30),

          // Apple Pay Button
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _processApplePay(context),
                borderRadius: BorderRadius.circular(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.apple, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    const Text(
                      'Pay with Apple Pay',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Security Info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.security, color: Colors.green[600], size: 16),
              const SizedBox(width: 8),
              Text(
                'Secured by Apple',
                style: TextStyle(
                  color: Colors.green[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _validateAndProcessPayment(
    BuildContext context,
    payment,
    List<dynamic> cartItems,
  ) {
    // التحقق من وجود المنتجات في السلة
    if (cartItems.isEmpty) {
      print('❌ No products in cart!');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'لا توجد منتجات في السلة',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.red[600],
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    print('📦 Processing payment with ${cartItems.length} items');
    for (int i = 0; i < cartItems.length; i++) {
      print('   ${i + 1}. ${cartItems[i]}');
    }

    // الحصول على القيم الحالية من CreditCardForm
    Map<String, String> currentValues = {};
    if (_creditCardFormKey.currentState != null) {
      currentValues = _creditCardFormKey.currentState!.getCurrentValues();
    }

    // التحقق من صحة البيانات
    bool isValid = true;
    List<String> missingFields = [];

    String cardNumber = currentValues['cardNumber'] ?? '';
    String cardholderName = currentValues['cardholderName'] ?? '';
    String expiryMonth = currentValues['expiryMonth'] ?? '';
    String expiryYear = currentValues['expiryYear'] ?? '';
    String cvv = currentValues['cvv'] ?? '';

    if (cardNumber.isEmpty || cardNumber.trim().isEmpty) {
      missingFields.add('Card Number');
      isValid = false;
    }
    if (cardholderName.isEmpty || cardholderName.trim().isEmpty) {
      missingFields.add('Cardholder Name');
      isValid = false;
    }
    if (expiryMonth.isEmpty || expiryMonth.trim().isEmpty) {
      missingFields.add('Expiry Month');
      isValid = false;
    }
    if (expiryYear.isEmpty || expiryYear.trim().isEmpty) {
      missingFields.add('Expiry Year');
      isValid = false;
    }
    if (cvv.isEmpty || cvv.trim().isEmpty) {
      missingFields.add('CVV');
      isValid = false;
    }

    print('Validation check:');
    print('Card Number: "$cardNumber"');
    print('Cardholder: "$cardholderName"');
    print('Expiry Month: "$expiryMonth"');
    print('Expiry Year: "$expiryYear"');
    print('CVV: "$cvv"');
    print('Is Valid: $isValid');

    if (!isValid) {
      // إظهار إشعار الخطأ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in all required fields: ${missingFields.join(', ')}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.red[600],
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    // إذا كانت البيانات صحيحة، تابع عملية الدفع
    print('All fields valid, processing payment...');
    context.read<PaymentCubit>().processPayment(cartItems, context);
  }

  void _processApplePay(BuildContext context) {
    // محاكاة عملية Apple Pay
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.apple, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 15),
            const Text('Apple Pay'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text(
              'Processing payment with Apple Pay...',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Use Touch ID or Face ID to confirm',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    // محاكاة تأكيد Apple Pay
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop(); // إغلاق dialog التحميل

      // عرض رسالة النجاح
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              const SizedBox(width: 10),
              const Text('Payment Successful!'),
            ],
          ),
          content: const Text(
            'Your Apple Pay payment has been processed successfully. You will receive an order confirmation email shortly.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/home');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }
}
