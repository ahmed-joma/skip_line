import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/cart_item.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addToCart(CartItem item) {
    // البحث عن المنتج الموجود في السلة
    final existingItemIndex = _items.indexWhere(
      (cartItem) => cartItem.productId == item.productId,
    );

    if (existingItemIndex != -1) {
      // إذا كان المنتج موجود، زيادة الكمية
      final existingItem = _items[existingItemIndex];
      _items[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
      // إذا لم يكن موجود، إضافة منتج جديد
      _items.add(item);
    }

    emit(CartLoaded(items: _items));
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    emit(CartLoaded(items: _items));
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final itemIndex = _items.indexWhere((item) => item.productId == productId);
    if (itemIndex != -1) {
      _items[itemIndex] = _items[itemIndex].copyWith(quantity: quantity);
      emit(CartLoaded(items: _items));
    }
  }

  void incrementQuantity(String productId) {
    final itemIndex = _items.indexWhere((item) => item.productId == productId);
    if (itemIndex != -1) {
      final currentItem = _items[itemIndex];
      _items[itemIndex] = currentItem.copyWith(
        quantity: currentItem.quantity + 1,
      );
      emit(CartLoaded(items: _items));
    }
  }

  void decrementQuantity(String productId) {
    final itemIndex = _items.indexWhere((item) => item.productId == productId);
    if (itemIndex != -1) {
      final currentItem = _items[itemIndex];
      if (currentItem.quantity > 1) {
        _items[itemIndex] = currentItem.copyWith(
          quantity: currentItem.quantity - 1,
        );
      } else {
        _items.removeAt(itemIndex);
      }
      emit(CartLoaded(items: _items));
    }
  }

  void clearCart() {
    _items.clear();
    emit(CartLoaded(items: _items));
  }

  bool isInCart(String productId) {
    return _items.any((item) => item.productId == productId);
  }

  int getItemQuantity(String productId) {
    final item = _items.firstWhere(
      (item) => item.productId == productId,
      orElse: () => const CartItem(
        id: '',
        productId: '',
        name: '',
        nameAr: '',
        description: '',
        descriptionAr: '',
        price: 0,
        weight: '',
        imagePath: '',
        category: '',
        categoryAr: '',
        quantity: 0,
      ),
    );
    return item.quantity;
  }
}
