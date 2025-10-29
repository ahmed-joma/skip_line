import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaymentHeader extends StatelessWidget {
  final double totalAmount;
  final String currency;
  final int vatRate;

  const PaymentHeader({
    Key? key,
    required this.totalAmount,
    required this.currency,
    required this.vatRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // التحقق من صحة القيم
    final safeTotalAmount =
        (totalAmount.isNaN || totalAmount.isInfinite || totalAmount < 0)
        ? 0.0
        : totalAmount;
    final safeVatRate = vatRate.clamp(0, 100);

    // حساب السعر مع الضريبة
    final taxAmount = safeTotalAmount * (safeVatRate / 100);
    final totalWithTax = safeTotalAmount + taxAmount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back button
        GestureDetector(
          onTap: () {
            if (Navigator.canPop(context)) {
              context.pop();
            } else {
              context.go('/cart');
            }
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF1E3A8A),
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
            Row(
              children: [
                const Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A8A).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.credit_card,
                    color: Color(0xFF1E3A8A),
                    size: 20,
                  ),
                ),
              ],
            ),

            // Price
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E3A8A).withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$currency ${totalWithTax.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Including VAT ($vatRate%)',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
