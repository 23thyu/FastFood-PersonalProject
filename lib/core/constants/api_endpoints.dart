/// API Endpoints Constants
class ApiEndpoints {
  // Base URL - thay đổi theo địa chỉ backend Node.js của bạn
  static const String baseUrl =
      'http://10.0.2.2:3003/api'; // Thay đổi IP nếu cần

  // Categories và products (existing)
  static const String categories = '$baseUrl/categories';
  static const String banners = '$baseUrl/banners';
  static const String products = '$baseUrl/products';
  static const String productsByCategory = '$baseUrl/products-by-category';

  // ⭐ THÊM Auth endpoints
  static const String login = '$baseUrl/users/login';
  static const String register = '$baseUrl/users/register';
  static const String logout = '$baseUrl/users/logout';

  // ⭐ THÊM User endpoints (tùy chọn)
  static const String userProfile = '$baseUrl/users/profile';
  static const String updateProfile = '$baseUrl/users/update';
}
