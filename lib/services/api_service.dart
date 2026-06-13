import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://dummyjson.com/products';

  Future<List<Product>> fetchProducts({int skip = 0, int limit = 10, String query = ''}) async {
    String url = query.isEmpty 
        ? '$baseUrl?limit=$limit&skip=$skip'
        : '$baseUrl/search?q=$query&limit=$limit&skip=$skip';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List productsJson = data['products'];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}