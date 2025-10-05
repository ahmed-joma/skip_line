import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/models/payment_model.dart';

class CreditCardForm extends StatefulWidget {
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
  State<CreditCardForm> createState() => CreditCardFormState();
}

class CreditCardFormState extends State<CreditCardForm> {
  Map<String, bool> _fieldErrors = {};
  late TextEditingController _cardNumberController;
  late TextEditingController _cardholderController;
  late TextEditingController _expiryMonthController;
  late TextEditingController _expiryYearController;
  late TextEditingController _cvvController;

  @override
  void initState() {
    super.initState();
    _fieldErrors = {
      'cardNumber': false,
      'cardholderName': false,
      'expiryMonth': false,
      'expiryYear': false,
      'cvv': false,
    };

    _cardNumberController = TextEditingController();
    _cardholderController = TextEditingController();
    _expiryMonthController = TextEditingController();
    _expiryYearController = TextEditingController();
    _cvvController = TextEditingController();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardholderController.dispose();
    _expiryMonthController.dispose();
    _expiryYearController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _validateField(String fieldName, String value) {
    setState(() {
      _fieldErrors[fieldName] = value.isEmpty;
    });
  }

  // دالة للتحقق من صحة تاريخ الانتهاء
  void _validateExpiryDate(String month, String year) {
    if (month.isNotEmpty && year.isNotEmpty) {
      final currentDate = DateTime.now();
      final currentYear = currentDate.year % 100; // آخر رقمين من السنة الحالية
      final currentMonth = currentDate.month;

      final expiryMonth = int.tryParse(month);
      final expiryYear = int.tryParse(year);

      if (expiryMonth != null && expiryYear != null) {
        bool isExpired = false;

        if (expiryYear < currentYear) {
          isExpired = true;
        } else if (expiryYear == currentYear && expiryMonth < currentMonth) {
          isExpired = true;
        }

        setState(() {
          _fieldErrors['expiryMonth'] = isExpired;
          _fieldErrors['expiryYear'] = isExpired;
        });
      }
    }
  }

  // دالة للحصول على القيم الحالية من الـ controllers
  Map<String, String> getCurrentValues() {
    return {
      'cardNumber': _cardNumberController.text,
      'cardholderName': _cardholderController.text,
      'expiryMonth': _expiryMonthController.text,
      'expiryYear': _expiryYearController.text,
      'cvv': _cvvController.text,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
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
                    controller: _cardNumberController,
                    onChanged: (value) {
                      widget.onCardNumberChanged(value);
                      _validateField('cardNumber', value);
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                      CardNumberInputFormatter(),
                    ],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'xxxx xxxx xxxx xxxx',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _fieldErrors['cardNumber']!
                          ? Colors.red
                          : Colors.black87,
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

          const SizedBox(height: 16),

          // Cardholder Name
          _buildFormField(
            label: 'Cardholder name',
            child: TextFormField(
              controller: _cardholderController,
              onChanged: (value) {
                // تحويل النص إلى حروف كبيرة ومنع الأرقام
                final upperValue = value.toUpperCase().replaceAll(
                  RegExp(r'[0-9]'),
                  '',
                );
                if (upperValue != value) {
                  _cardholderController.value = TextEditingValue(
                    text: upperValue,
                    selection: TextSelection.collapsed(
                      offset: upperValue.length,
                    ),
                  );
                }
                widget.onCardholderChanged(upperValue);
                _validateField('cardholderName', upperValue);
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                UpperCaseTextFormatter(),
              ],
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter cardholder name',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: _fieldErrors['cardholderName']!
                    ? Colors.red
                    : Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 16),

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
                          controller: _expiryMonthController,
                          onChanged: (value) {
                            widget.onExpiryChanged(
                              value,
                              widget.payment.expiryYear,
                            );
                            _validateField('expiryMonth', value);
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'MM',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: _fieldErrors['expiryMonth']!
                                ? Colors.red
                                : Colors.black87,
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
                          controller: _expiryYearController,
                          onChanged: (value) {
                            // التحقق من صحة التاريخ
                            _validateExpiryDate(
                              _expiryMonthController.text,
                              value,
                            );
                            widget.onExpiryChanged(
                              widget.payment.expiryMonth,
                              value,
                            );
                            _validateField('expiryYear', value);
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'YY',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: _fieldErrors['expiryYear']!
                                ? Colors.red
                                : Colors.black87,
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
                          controller: _cvvController,
                          onChanged: (value) {
                            widget.onCVVChanged(value);
                            _validateField('cvv', value);
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '123',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: _fieldErrors['cvv']!
                                ? Colors.red
                                : Colors.black87,
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
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

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
