import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String selectedMethod;
  final Function(String) onMethodChanged;

  const PaymentMethodSelector({
    Key? key,
    required this.selectedMethod,
    required this.onMethodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
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
      child: Row(
        children: [
          // Credit Card Button
          Expanded(
            child: GestureDetector(
              onTap: () => onMethodChanged('Credit card'),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: selectedMethod == 'Credit card'
                      ? const Color(0xFF1E3A8A)
                      : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.credit_card,
                      color: selectedMethod == 'Credit card'
                          ? Colors.white
                          : Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Credit card',
                      style: TextStyle(
                        color: selectedMethod == 'Credit card'
                            ? Colors.white
                            : Colors.grey[600],
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Apple Pay Button
          Expanded(
            child: GestureDetector(
              onTap: () => onMethodChanged('Apple Pay'),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: selectedMethod == 'Apple Pay'
                      ? const Color(0xFF1E3A8A)
                      : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.apple,
                      color: selectedMethod == 'Apple Pay'
                          ? Colors.white
                          : Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Apple Pay',
                      style: TextStyle(
                        color: selectedMethod == 'Apple Pay'
                            ? Colors.white
                            : Colors.grey[600],
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
