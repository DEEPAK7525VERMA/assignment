import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class LocalStorageService {
  static const String _wishlistKey = 'wishlist_items_v2'; // Changed key to reset old data
  static const String _cartKey = 'cart_items_v2';
  static const String _cacheKey = 'products_cache';

  // --- WISHLIST LOGIC ---
  Future<List<Product>> getWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? items = prefs.getStringList(_wishlistKey);
    if (items == null) return [];
    return items.map((str) => Product.fromJson(json.decode(str))).toList();
  }

  Future<void> saveWishlist(List<Product> wishlist) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> stringItems = wishlist.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList(_wishlistKey, stringItems);
  }

  // --- CART LOGIC ---
  Future<List<CartItem>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? cartStrings = prefs.getStringList(_cartKey);
    if (cartStrings == null) return [];
    return cartStrings.map((str) => CartItem.fromJson(json.decode(str))).toList();
  }

  Future<void> saveCart(List<CartItem> cart) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cartStrings = cart.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList(_cartKey, cartStrings);
  }

  // --- OFFLINE CACHING LOGIC ---
  Future<void> cacheProducts(String jsonString) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, jsonString);
  }

  Future<String?> getCachedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cacheKey);
  }
}