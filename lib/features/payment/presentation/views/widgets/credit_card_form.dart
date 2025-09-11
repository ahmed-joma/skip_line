import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/models/payment_model.dart';

class CreditCardForm extends StatelessWidget {
  final PaymentModel payment;
  final Function(String) onCardNumberChanged;
  final Function(String) onCardholderChanged;
  final Function(String, String) onExpiryChanged;
  final Function(String) onCVVChanged;

  const CreditCardForm({
    Key? key,
    required this.payment,
    required this.onCardNumberChanged,
    required this.onCardholderChanged,
    required this.onExpiryChanged,
    required this.onCVVChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Number
          _buildFormField(
            label: 'Card number',
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: payment.cardNumber,
                    onChanged: onCardNumberChanged,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                      CardNumberInputFormatter(),
                    ],
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '1234 5678 9012 3456',
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Card logos
                Row(
                  children: [
                    // Mastercard logo
                    Container(
                      width: 30,
                      height: 20,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEB001B), Color(0xFFF79E1B)],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: const Center(
                        child: Text(
                          'MC',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    // Generic card icon
                    Icon(Icons.credit_card, color: Colors.grey[400], size: 20),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Cardholder Name
          _buildFormField(
            label: 'Cardholder name',
            child: TextFormField(
              initialValue: payment.cardholderName,
              onChanged: onCardholderChanged,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter cardholder name',
              ),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),

          const SizedBox(height: 20),

          // Expiry Date and CVV Row
          Row(
            children: [
              // Expiry Date
              Expanded(
                flex: 2,
                child: _buildFormField(
                  label: 'Expiry date',
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: payment.expiryMonth,
                          onChanged: (value) =>
                              onExpiryChanged(value, payment.expiryYear),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'MM',
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Text(
                        ' / ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: payment.expiryYear,
                          onChanged: (value) =>
                              onExpiryChanged(payment.expiryMonth, value),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'YYYY',
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 20),

              // CVV
              Expanded(
                child: _buildFormField(
                  label: 'CVV / CVC',
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: payment.cvv,
                          onChanged: onCVVChanged,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '123',
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.help_outline,
                        color: Colors.grey[400],
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: child,
        ),
      ],
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.length <= 4) {
      return newValue;
    }

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
