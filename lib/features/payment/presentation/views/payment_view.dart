import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../manager/payment_cubit.dart';
import '../manager/payment_state.dart';
import 'widgets/payment_header.dart';
import 'widgets/payment_method_selector.dart';
import 'widgets/credit_card_form.dart';
import 'widgets/payment_button.dart';

class PaymentView extends StatelessWidget {
  final double totalAmount;

  const PaymentView({Key? key, required this.totalAmount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // طباعة السعر للتأكد من استلامه
    print('PaymentView received totalAmount: $totalAmount');

    return BlocProvider(
      create: (context) => PaymentCubit()..loadPayment(totalAmount),
      child: PaymentViewContent(totalAmount: totalAmount),
    );
  }
}

class PaymentViewContent extends StatelessWidget {
  final double totalAmount;

  const PaymentViewContent({Key? key, required this.totalAmount})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<PaymentCubit, PaymentState>(
          listener: (context, state) {
            if (state is PaymentSuccess) {
              _showSuccessDialog(context);
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
                      totalAmount: totalAmount,
                      currency: state.payment.currency,
                      gstRate: 15,
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

                    const SizedBox(height: 30),

                    // Credit card form
                    if (state.payment.paymentMethod == 'Credit card')
                      CreditCardForm(
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
                      _buildApplePaySection(context, totalAmount),

                    const SizedBox(height: 20),

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

                    const SizedBox(height: 40),

                    // Payment button
                    PaymentButton(
                      totalAmount: totalAmount,
                      currency: state.payment.currency,
                      onPressed: () {
                        _validateAndProcessPayment(context, state.payment);
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

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 30),
            const SizedBox(width: 10),
            const Text('Payment Successful!'),
          ],
        ),
        content: const Text(
          'Your payment has been processed successfully. You will receive an order confirmation email shortly.',
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
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 30),
            const SizedBox(width: 10),
            const Text('Payment Failed'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
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

  void _validateAndProcessPayment(BuildContext context, payment) {
    // التحقق من صحة البيانات
    bool isValid = true;
    List<String> missingFields = [];

    if (payment.cardNumber.isEmpty) {
      missingFields.add('Card Number');
      isValid = false;
    }
    if (payment.cardholderName.isEmpty) {
      missingFields.add('Cardholder Name');
      isValid = false;
    }
    if (payment.expiryMonth.isEmpty) {
      missingFields.add('Expiry Month');
      isValid = false;
    }
    if (payment.expiryYear.isEmpty) {
      missingFields.add('Expiry Year');
      isValid = false;
    }
    if (payment.cvv.isEmpty) {
      missingFields.add('CVV');
      isValid = false;
    }

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
    context.read<PaymentCubit>().processPayment();
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
