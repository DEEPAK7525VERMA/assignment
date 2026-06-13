import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'local_storage_service.dart';

class ApiService {
  static const String baseUrl = 'https://dummyjson.com/products';
  final LocalStorageService _storageService = LocalStorageService();

  Future<List<Product>> fetchProducts({
    int skip = 0, 
    int limit = 10, 
    String query = '', 
    String category = 'All'
  }) async {
    String url;
    
    if (query.isNotEmpty) {
      url = '$baseUrl/search?q=$query&limit=$limit&skip=$skip';
    } else if (category != 'All') {
      url = '$baseUrl/category/$category?limit=$limit&skip=$skip';
    } else {
      url = '$baseUrl?limit=$limit&skip=$skip';
    }

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Cache the fresh data if it's the main list
        if (query.isEmpty && category == 'All' && skip == 0) {
          await _storageService.cacheProducts(response.body);
        }
        
        final data = json.decode(response.body);
        final List productsJson = data['products'];
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } on SocketException catch (_) {
      // OFFLINE MODE: Catch no internet connection and load from cache
      final cachedData = await _storageService.getCachedProducts();
      if (cachedData != null) {
        final data = json.decode(cachedData);
        final List productsJson = data['products'];
        return productsJson.map((json) => Product.fromJson(json)).toList();
      }
      throw Exception('No internet connection and no cached data available.');
    }
  }
}