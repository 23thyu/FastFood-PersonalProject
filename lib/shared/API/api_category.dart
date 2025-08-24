import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../../core/constants/api_endpoints.dart';

class ApiService {
  // Lấy danh sách categories
  static Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.categories),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> categoryList = data['data'];

        return categoryList.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('Lỗi kết nối: $e');
    }
  }
}
