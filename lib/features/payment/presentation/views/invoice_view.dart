import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InvoiceView extends StatelessWidget {
  final double totalAmount;
  final String currency;
  final List<Map<String, dynamic>> cartItems;

  const InvoiceView({
    super.key,
    required this.totalAmount,
    required this.currency,
    required this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    // طباعة السعر للتأكد من وصوله
    print('InvoiceView received totalAmount: $totalAmount');

    // Calculate subtotal, tax, and total
    double subtotal = 0.0;
    for (var item in cartItems) {
      subtotal += (item['price'] as double) * (item['quantity'] as int);
    }

    double tax = subtotal * 0.15; // 15% tax
    double otherFees = 0.0;
    double finalTotal = subtotal + tax + otherFees;

    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Top spacing
            const SizedBox(height: 40),

            // SkipLine Logo
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  // Logo image
                  Image.asset('assets/images/logo.png', width: 80, height: 80),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            // Invoice container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Thank you message
                  const Text(
                    'Thank you for using\nSkipLine!',
                    style: TextStyle(fontSize: 30, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // Order title
                  const Text(
                    'Your Order',
                    style: TextStyle(fontSize: 22, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  // Order date and time
                  Text(
                    'Monday, Dec 28 2025 at 4:13pm',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  // Order items
                  ...cartItems.map(
                    (item) => _buildOrderItem(
                      item['name'] as String,
                      (item['price'] as double) * (item['quantity'] as int),
                      item['quantity'] as int,
                    ),
                  ),

                  const Divider(height: 24),

                  // Subtotal
                  _buildPriceRow('Subtotal', subtotal),
                  const SizedBox(height: 8),

                  // Tax
                  _buildPriceRow('Tax (15%)', tax),
                  const SizedBox(height: 8),

                  // Other fees
                  _buildPriceRow('Other hidden fee', otherFees),

                  const Divider(height: 24),

                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '${currency}${finalTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Center text under total
                  const Text(
                    'Thanks for being a great customer.',
                    style: TextStyle(fontSize: 14, color: Color(0xFF123459)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // View My Account button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF123459),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'View My Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Footer message
            const SizedBox(height: 20),

            // Company info
            Text(
              'Company, Self-Payment Services',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              "Don't like these messages? Unsubscribe.",
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 19),

            Text(
              'Powered by HTMLemail.io',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(String name, double price, int quantity) {
    // طباعة بيانات المنتج للتأكد
    print('Order Item - Name: $name, Price: $price, Quantity: $quantity');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '$name (x$quantity)',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
          Text(
            '${currency}${price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
        Text(
          '${currency}${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
