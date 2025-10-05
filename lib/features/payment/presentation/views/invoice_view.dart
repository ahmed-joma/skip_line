import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/invoice_data_storage.dart';

class InvoiceView extends StatefulWidget {
  final double totalAmount;
  final String currency;
  final int? orderId;
  final List<dynamic>? cartItems; // إضافة بيانات السلة

  const InvoiceView({
    super.key,
    required this.totalAmount,
    required this.currency,
    this.orderId,
    this.cartItems, // إضافة المعامل الجديد
  });

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  List<Map<String, dynamic>> orderItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrderData();
  }

  Future<void> _loadOrderData() async {
    print('🔄 Loading order data for ID: ${widget.orderId}');

    // جلب البيانات من التخزين المؤقت
    final invoiceData = InvoiceDataStorage.getInvoiceData();
    final cartItems = invoiceData['cartItems'] as List<dynamic>;

    print('🔄 Cart items available from storage: ${cartItems.length}');

    // استخدام البيانات المحلية فقط - لا نعتمد على API
    if (cartItems.isNotEmpty) {
      print('✅ Using local cart data from storage');

      setState(() {
        orderItems = cartItems.map((item) {
          return {
            'name': item.nameAr ?? item.name ?? 'Unknown Product',
            'nameEn': item.name ?? 'Unknown Product',
            'price': item.price ?? 0.0,
            'quantity': item.quantity ?? 1,
            'total': (item.price ?? 0.0) * (item.quantity ?? 1),
          };
        }).toList();
        isLoading = false;
      });

      print('📦 Loaded ${orderItems.length} order items from storage:');
      for (int i = 0; i < orderItems.length; i++) {
        print(
          '   ${i + 1}. ${orderItems[i]['name']} - ${orderItems[i]['price']} ر.س x${orderItems[i]['quantity']}',
        );
      }
    } else {
      print('❌ No cart items available in storage');
      setState(() {
        orderItems = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // طباعة تشخيصية للبيانات
    print('🔍 Invoice View - Order Items Count: ${orderItems.length}');
    print('🔍 Invoice View - Order Items: $orderItems');
    print('🔍 Invoice View - Order ID: ${widget.orderId}');

    // Calculate subtotal, tax, and total
    double subtotal = 0.0;
    for (var item in orderItems) {
      subtotal += (item['price'] as double) * (item['quantity'] as int);
    }

    print('🔍 Invoice View - Calculated Subtotal: $subtotal');

    double tax = subtotal * 0.15; // 15% tax
    double otherFees = 0.0;
    double finalTotal = subtotal + tax + otherFees;

    print('🔍 Invoice View - Final Total: $finalTotal');

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

                  // Order items - عرض المنتجات مباشرة
                  ...orderItems.map(
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
                        '${widget.currency}${finalTotal.toStringAsFixed(2)}',
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
            '${widget.currency}${price.toStringAsFixed(2)}',
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
          '${widget.currency}${amount.toStringAsFixed(2)}',
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
