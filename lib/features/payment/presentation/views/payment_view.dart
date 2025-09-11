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
                        context.read<PaymentCubit>().processPayment();
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
}
