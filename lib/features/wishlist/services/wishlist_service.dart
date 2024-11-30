import 'package:pin/features/exchanges/models/Product.dart';

class WishlistService {
  static final WishlistService _instance = WishlistService._internal();
  factory WishlistService() => _instance;
  WishlistService._internal();

  final List<Product> _wishlistItems = [];

  List<Product> get wishlistItems => List.unmodifiable(_wishlistItems);

  void addToWishlist(Product product) {
    if (!_wishlistItems.contains(product)) {
      _wishlistItems.add(product);
    }
  }

  void removeFromWishlist(Product product) {
    _wishlistItems.remove(product);
  }

  bool isInWishlist(Product product) {
    return _wishlistItems.contains(product);
  }
}
