// Import thư viện cần thiết
import 'dart:convert'; // Thư viện chuyển đổi JSON
import 'package:http/http.dart' as http; // Thư viện HTTP
import '../../core/constants/api_endpoints.dart'; // Import API endpoints
import '../../shared/models/product_models.dart'; // Import Product model

//Class chưa API call product
class ProductApiService {
  // Hàm lấy sản phẩm theo category ID
  static Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      // Tạo URL với query parameter
      final url =
          '${ApiEndpoints.baseUrl}/products-by-category?category_id=$categoryId';
      print('🔄 Đang gọi API Product: $url'); // Log debug

      // Gọi HTTP GET request
      final response = await http
          .get(
            Uri.parse(url), // Chuyển string thành Uri
            headers: {
              'Content-Type': 'application/json', // Header content type
              'Accept': 'application/json', // Header accept
            },
          )
          .timeout(const Duration(seconds: 15)); // Timeout 15 giây

      // Log response để debug
      print('📡 Product Response status: ${response.statusCode}');
      print('📝 Product Response body: ${response.body}');

      // Kiểm tra status code thành công
      if (response.statusCode == 200) {
        // Parse JSON response
        final Map<String, dynamic> data = json.decode(response.body);

        // Kiểm tra có field 'data' không
        if (data['data'] != null) {
          final List<dynamic> productList =
              data['data']; // Lấy danh sách products

          // Convert từng item thành Product object
          return productList.map((json) => Product.fromJson(json)).toList();
        } else {
          throw Exception('Dữ liệu không đúng định dạng');
        }
      } else {
        throw Exception('Server trả về lỗi: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ ProductFF API Error: $e'); // Log lỗi
      throw Exception('Lỗi khi tải sản phẩm: $e');
    }
  }
}
