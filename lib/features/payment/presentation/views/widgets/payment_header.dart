import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaymentHeader extends StatelessWidget {
  final double totalAmount;
  final String currency;
  final int gstRate;

  const PaymentHeader({
    Key? key,
    required this.totalAmount,
    required this.currency,
    required this.gstRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back button
        IconButton(
          onPressed: () => context.pop(),
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.blue,
              size: 20,
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Title and price row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title
            const Text(
              'Checkout',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            // Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$currency ${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Including GST ($gstRate%)',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
