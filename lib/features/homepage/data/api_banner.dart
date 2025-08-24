// Import thư viện cần thiết
import 'dart:convert'; // Thư viện để chuyển đổi JSON
import 'package:http/http.dart' as http; // Thư viện để gọi HTTP API
import 'package:fastfood_app/core/constants/api_endpoints.dart'; // Import các endpoint API
import 'package:fastfood_app/features/homepage/domain/banner_models.dart';

class BannerApiService {
  static Future<List<Banner>> getBanners() async {
    try {
      //chuyển string thành uri
      final response = await http
          .get(
            Uri.parse(ApiEndpoints.banners),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      //kiểm tra nếu API thành tông thì trả về 200
      if (response.statusCode == 200) {
        //chuyển đổi json string thành map
        final Map<String, dynamic> data = json.decode(response.body);
        //kiểm tra xem có field data k
        if (data['data'] != null) {
          final List<dynamic> bannerList = data['data'];
          return bannerList.map((item) => Banner.fromJson(item)).toList();
        } else {
          throw Exception('No data found');
        }
      } else {
        //nếu không thành công thì trả về lỗi
        throw Exception('Failed to load banners: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching banners: $e');
    }
  }
}
