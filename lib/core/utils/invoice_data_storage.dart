import '../../features/my_cart/data/models/cart_item.dart';

class InvoiceDataStorage {
  static List<CartItem>? _cartItems;
  static double? _totalAmount;
  static String? _currency;
  static int? _orderId;

  // حفظ البيانات
  static void saveInvoiceData({
    required List<CartItem> cartItems,
    required double totalAmount,
    required String currency,
    required int orderId,
  }) {
    print('💾 InvoiceDataStorage - BEFORE saving:');
    print('💾 Previous Cart Items Count: ${_cartItems?.length ?? 0}');
    print('💾 Previous Total Amount: $_totalAmount');
    print('💾 Previous Order ID: $_orderId');
    print('💾 Input Cart Items Count: ${cartItems.length}');
    print('💾 Input Cart Items: $cartItems');

    // إنشاء نسخة منفصلة من البيانات لتجنب التأثير عليها
    _cartItems = List<CartItem>.from(cartItems);
    _totalAmount = totalAmount;
    _currency = currency;
    _orderId = orderId;

    print('💾 InvoiceDataStorage - AFTER saving:');
    print('💾 Cart Items Count: ${_cartItems?.length ?? 0}');
    print('💾 Total Amount: $_totalAmount');
    print('💾 Order ID: $_orderId');
    print('💾 Cart Items: $_cartItems');

    // التحقق من أن البيانات محفوظة بشكل صحيح
    if (_cartItems == null || _cartItems!.isEmpty) {
      print('❌ ERROR: Cart items are null or empty after saving!');
    } else {
      print('✅ SUCCESS: Cart items saved correctly');
    }

    // التحقق من البيانات بعد فترة قصيرة
    Future.delayed(const Duration(milliseconds: 500), () {
      print('💾 InvoiceDataStorage - CHECKING after 500ms:');
      print('💾 Cart Items Count: ${_cartItems?.length ?? 0}');
      print('💾 Cart Items: $_cartItems');
    });
  }

  // جلب البيانات
  static Map<String, dynamic> getInvoiceData() {
    print('💾 InvoiceDataStorage - Data retrieved:');
    print('💾 Cart Items Count: ${_cartItems?.length ?? 0}');
    print('💾 Total Amount: $_totalAmount');
    print('💾 Order ID: $_orderId');
    print('💾 Cart Items: $_cartItems');

    final result = {
      'cartItems': _cartItems ?? [],
      'totalAmount': _totalAmount ?? 0.0,
      'currency': _currency ?? 'SAR',
      'orderId': _orderId,
    };

    print('💾 InvoiceDataStorage - Returning result:');
    print(
      '💾 Result Cart Items Count: ${(result['cartItems'] as List).length}',
    );
    print('💾 Result Cart Items: ${result['cartItems']}');

    return result;
  }

  // مسح البيانات
  static void clearInvoiceData() {
    print('💾 InvoiceDataStorage - CLEARING DATA!');
    print('💾 Before clearing - Cart Items Count: ${_cartItems?.length ?? 0}');
    print('💾 Before clearing - Total Amount: $_totalAmount');
    print('💾 Before clearing - Order ID: $_orderId');

    _cartItems = null;
    _totalAmount = null;
    _currency = null;
    _orderId = null;

    print('💾 InvoiceDataStorage - Data cleared');
  }
}
