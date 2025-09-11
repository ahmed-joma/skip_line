import '../../data/models/payment_model.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoaded extends PaymentState {
  final PaymentModel payment;

  PaymentLoaded(this.payment);
}

class PaymentProcessing extends PaymentState {}

class PaymentSuccess extends PaymentState {}

class PaymentError extends PaymentState {
  final String message;

  PaymentError(this.message);
}

class PaymentFieldError extends PaymentState {
  final String fieldName;
  final bool hasError;

  PaymentFieldError(this.fieldName, this.hasError);
}
