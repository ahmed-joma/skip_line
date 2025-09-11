import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/payment_state.dart';
import '../../data/models/payment_model.dart';

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

  void processPayment() {
    if (state is PaymentLoaded) {
      emit(PaymentProcessing());

      // محاكاة عملية الدفع
      Future.delayed(const Duration(seconds: 2), () {
        emit(PaymentSuccess());
      });
    }
  }

  void resetPayment() {
    emit(PaymentInitial());
  }
}
