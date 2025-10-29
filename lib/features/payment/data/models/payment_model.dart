class PaymentModel {
  final double totalAmount;
  final double vatAmount;
  final double subtotalAmount;
  final String currency;
  final String paymentMethod;
  final String cardNumber;
  final String cardholderName;
  final String expiryMonth;
  final String expiryYear;
  final String cvv;
  final String email;

  PaymentModel({
    required this.totalAmount,
    required this.vatAmount,
    required this.subtotalAmount,
    this.currency = 'SR',
    this.paymentMethod = 'Credit card',
    this.cardNumber = '5261 4141 0151 8472',
    this.cardholderName = 'Reema',
    this.expiryMonth = '06',
    this.expiryYear = '2030',
    this.cvv = '915',
    this.email = '',
  });

  PaymentModel copyWith({
    double? totalAmount,
    double? vatAmount,
    double? subtotalAmount,
    String? currency,
    String? paymentMethod,
    String? cardNumber,
    String? cardholderName,
    String? expiryMonth,
    String? expiryYear,
    String? cvv,
    String? email,
  }) {
    return PaymentModel(
      totalAmount: totalAmount ?? this.totalAmount,
      vatAmount: vatAmount ?? this.vatAmount,
      subtotalAmount: subtotalAmount ?? this.subtotalAmount,
      currency: currency ?? this.currency,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      cardNumber: cardNumber ?? this.cardNumber,
      cardholderName: cardholderName ?? this.cardholderName,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      cvv: cvv ?? this.cvv,
      email: email ?? this.email,
    );
  }
}
