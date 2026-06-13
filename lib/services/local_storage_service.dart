import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _wishlistKey = 'wishlist_ids';
  static const String _cacheKey = 'products_cache';

  // --- WISHLIST LOGIC ---
  Future<List<int>> getWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? items = prefs.getStringList(_wishlistKey);
    if (items == null) return [];
    return items.map((id) => int.parse(id)).toList();
  }

  Future<void> saveWishlist(List<int> wishlistIds) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> stringIds = wishlistIds.map((id) => id.toString()).toList();
    await prefs.setStringList(_wishlistKey, stringIds);
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