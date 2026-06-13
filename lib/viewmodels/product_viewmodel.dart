import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

class ProductViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocalStorageService _storageService = LocalStorageService();

  List<Product> _products = [];
  List<int> _wishlistIds = [];
  
  bool _isLoading = false;
  bool _hasMore = true;
  int _skip = 0;
  final int _limit = 10;
  String _searchQuery = '';
  
  String _selectedCategory = 'All';
  // A predefined list of some categories from DummyJSON
  final List<String> _categories = ['All', 'beauty', 'fragrances', 'furniture', 'groceries'];

  List<Product> get products => _products;
  List<int> get wishlistIds => _wishlistIds;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String get selectedCategory => _selectedCategory;
  List<String> get categories => _categories;

  ProductViewModel() {
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    _wishlistIds = await _storageService.getWishlist();
    notifyListeners();
  }

  bool isInWishlist(int productId) {
    return _wishlistIds.contains(productId);
  }

  Future<void> toggleWishlist(int productId) async {
    if (_wishlistIds.contains(productId)) {
      _wishlistIds.remove(productId);
    } else {
      _wishlistIds.add(productId);
    }
    await _storageService.saveWishlist(_wishlistIds);
    notifyListeners();
  }

  void setCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    _searchQuery = ''; // Clear search when switching categories
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