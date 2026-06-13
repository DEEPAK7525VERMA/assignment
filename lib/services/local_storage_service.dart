import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _wishlistKey = 'wishlist_ids';

  // Fetch the saved wishlist IDs
  Future<List<int>> getWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? items = prefs.getStringList(_wishlistKey);
    
    if (items == null) return [];
    // Convert the saved strings back to integers
    return items.map((id) => int.parse(id)).toList();
  }

  // Save the updated wishlist IDs
  Future<void> saveWishlist(List<int> wishlistIds) async {
    final prefs = await SharedPreferences.getInstance();
    // SharedPreferences prefers lists of strings, so we convert them
    final List<String> stringIds = wishlistIds.map((id) => id.toString()).toList();
    await prefs.setStringList(_wishlistKey, stringIds);
  }
}