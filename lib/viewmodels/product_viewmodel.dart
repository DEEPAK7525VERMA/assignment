import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

class ProductViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocalStorageService _storageService = LocalStorageService();

  List<Product> _products = [];
  List<Product> _wishlistItems = []; // Upgraded to hold full Product objects
  List<CartItem> _cartItems = []; // Upgraded to hold CartItem objects
  
  bool _isLoading = false;
  bool _hasMore = true;
  int _skip = 0;
  final int _limit = 10;
  String _searchQuery = '';
  
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'beauty', 'fragrances', 'furniture', 'groceries'];

  List<Product> get products => _products;
  List<Product> get wishlistItems => _wishlistItems;
  List<CartItem> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String get selectedCategory => _selectedCategory;
  List<String> get categories => _categories;

  ProductViewModel() {
    _loadWishlist();
    _loadCart();
  }

  // --- WISHLIST LOGIC ---
  Future<void> _loadWishlist() async {
    _wishlistItems = await _storageService.getWishlist();
    notifyListeners();
  }

  bool isInWishlist(int productId) {
    return _wishlistItems.any((item) => item.id == productId);
  }

  Future<void> toggleWishlist(Product product) async {
    if (isInWishlist(product.id)) {
      _wishlistItems.removeWhere((item) => item.id == product.id);
    } else {
      _wishlistItems.add(product);
    }
    await _storageService.saveWishlist(_wishlistItems);
    notifyListeners();
  }

  // --- CART LOGIC ---
  Future<void> _loadCart() async {
    _cartItems = await _storageService.getCart();
    notifyListeners();
  }

  int getCartQuantity(int productId) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    return index >= 0 ? _cartItems[index].quantity : 0;
  }

  Future<void> addToCart(Product product) async {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(CartItem(product: product, quantity: 1));
    }
    await _storageService.saveCart(_cartItems);
    notifyListeners();
  }

  Future<void> removeFromCart(int productId) async {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index < 0) return;

    if (_cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
    } else {
      _cartItems.removeAt(index);
    }
    await _storageService.saveCart(_cartItems);
    notifyListeners();
  }

  double get cartTotal {
    return _cartItems.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  // --- FILTER & API LOGIC ---
  void setCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    _searchQuery = ''; 
    fetchProducts(refresh: true);
  }

  Future<void> fetchProducts({bool refresh = false}) async {
    if (_isLoading || (!_hasMore && !refresh)) return;

    if (refresh) {
      _skip = 0;
      _products.clear();
      _hasMore = true;
    }

    _isLoading = true;
    Future.microtask(() => notifyListeners());

    try {
      final newProducts = await _apiService.fetchProducts(
        skip: _skip, 
        limit: _limit, 
        query: _searchQuery,
        category: _selectedCategory,
      );

      if (newProducts.length < _limit) {
        _hasMore = false;
      }

      _products.addAll(newProducts);
      _skip += _limit;
    } catch (e) {
      debugPrint("Error fetching products: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchProducts(String query) {
    _searchQuery = query;
    fetchProducts(refresh: true);
  }
}