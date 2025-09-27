import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/payment_state.dart';
import '../../data/models/payment_model.dart';
import '../../../../core/services/order_service.dart';
import '../../../../shared/widgets/top_notification.dart';
import '../../../../shared/constants/language_manager.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  void loadPayment(double totalAmount) {
    // حساب الضريبة 15%
    double gstRate = 0.15;
    double gstAmount = totalAmount * gstRate;
    double subtotalAmount = totalAmount - gstAmount;

    final payment = PaymentModel(
      totalAmount: totalAmount,
      gstAmount: gstAmount,
      subtotalAmount: subtotalAmount,
    );

    emit(PaymentLoaded(payment));
  }

  void updatePaymentMethod(String method) {
    if (state is PaymentLoaded) {
      final currentPayment = (state as PaymentLoaded).payment;
      final updatedPayment = currentPayment.copyWith(paymentMethod: method);
      emit(PaymentLoaded(updatedPayment));
    }
  }

  void updateCardNumber(String cardNumber) {
    if (state is PaymentLoaded) {
      final currentPayment = (state as PaymentLoaded).payment;
      final updatedPayment = currentPayment.copyWith(cardNumber: cardNumber);
      emit(PaymentLoaded(updatedPayment));
    }
  }

  void updateCardholderName(String name) {
    if (state is PaymentLoaded) {
      final currentPayment = (state as PaymentLoaded).payment;
      final updatedPayment = currentPayment.copyWith(cardholderName: name);
      emit(PaymentLoaded(updatedPayment));
    }
  }

  void updateExpiryDate(String month, String year) {
    if (state is PaymentLoaded) {
      final currentPayment = (state as PaymentLoaded).payment;
      final updatedPayment = currentPayment.copyWith(
        expiryMonth: month,
        expiryYear: year,
      );
      emit(PaymentLoaded(updatedPayment));
    }
  }

  void updateCVV(String cvv) {
    if (state is PaymentLoaded) {
      final currentPayment = (state as PaymentLoaded).payment;
      final updatedPayment = currentPayment.copyWith(cvv: cvv);
      emit(PaymentLoaded(updatedPayment));
    }
  }

  void updateEmail(String email) {
    if (state is PaymentLoaded) {
      final currentPayment = (state as PaymentLoaded).payment;
      final updatedPayment = currentPayment.copyWith(email: email);
      emit(PaymentLoaded(updatedPayment));
    }
  }

  Future<void> processPayment(
    List<dynamic> cartItems,
    BuildContext context,
  ) async {
    if (state is PaymentLoaded) {
      emit(PaymentProcessing());

      try {
        // إنشاء الطلب أولاً
        print('🚀 Creating order before payment...');
        final orderResult = await OrderService.createOrder(cartItems);

        if (orderResult.isSuccess && orderResult.data != null) {
          print(
            '✅ Order created successfully! Order ID: ${orderResult.orderId}',
          );

          // إظهار إشعار النجاح
          final languageManager = LanguageManager();
          final isArabic = languageManager.isArabic;

          TopNotification.show(
            context,
            isArabic
                ? 'تم إنشاء الطلب بنجاح! رقم الطلب: ${orderResult.orderId}'
                : 'Order created successfully! Order ID: ${orderResult.orderId}',
            isError: false,
          );

          // محاكاة عملية الدفع
          await Future.delayed(const Duration(seconds: 2));

          // التحقق من أن الـ cubit لا يزال نشطاً
          if (!isClosed) {
            emit(PaymentSuccess(orderId: orderResult.orderId));
          }
        } else {
          print('❌ Failed to create order: ${orderResult.msg}');
          if (!isClosed) {
            emit(PaymentError('Failed to create order: ${orderResult.msg}'));
          }
        }
      } catch (e) {
        print('❌ Error during payment process: $e');
        if (!isClosed) {
          emit(PaymentError('Payment failed: $e'));
        }
      }
    }
  }

  void setFieldError(String fieldName, bool hasError) {
    if (state is PaymentLoaded) {
      // يمكن إضافة منطق إدارة الأخطاء هنا
      // emit(PaymentFieldError(fieldName, hasError));
    }
  }

  void resetPayment() {
    emit(PaymentInitial());
  }
}
