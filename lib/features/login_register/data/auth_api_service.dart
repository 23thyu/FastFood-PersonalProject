import 'dart:convert'; // Import để encode/decode JSON
import 'package:http/http.dart' as http; // Import HTTP package
import '../../../core/constants/api_endpoints.dart'; // Import API endpoints
import '../domain/user_model.dart'; // Import User model

// Service class để xử lý các API calls liên quan đến authentication
class AuthApiService {
  // Hàm đăng nhập với phone và password
  static Future<User> login({
    required String phone, // Số điện thoại (bắt buộc)
    required String password, // Mật khẩu (bắt buộc)
  }) async {
    try {
      print('🔄 AuthAPI: Bắt đầu đăng nhập với phone: $phone');

      // Tạo URL endpoint cho login
      final url = Uri.parse('${ApiEndpoints.baseUrl}/users/login');
      print('📍 AuthAPI: URL = $url');

      // Tạo request body
      final requestBody = {
        'phone': phone, // Số điện thoại
        'password': password, // Mật khẩu
      };
      print('📤 AuthAPI: Request body = $requestBody');

      // Gửi POST request với timeout
      final response = await http
          .post(
            url, // URL endpoint
            headers: {
              'Content-Type': 'application/json', // Header content type
              'Accept': 'application/json', // Header accept
            },
            body: jsonEncode(requestBody), // Convert request body thành JSON
          )
          .timeout(
            const Duration(seconds: 10), // ⭐ THÊM: Timeout 10 giây
            onTimeout: () {
              throw Exception('Kết nối quá chậm. Vui lòng thử lại.');
            },
          );

      print('📥 AuthAPI: Response status = ${response.statusCode}');
      print('📥 AuthAPI: Response body = ${response.body}');

      // ⭐ XỬ LÝ CÁC STATUS CODE VỚI THÔNG BÁO THÂN THIỆN
      if (response.statusCode == 200) {
        // Thành công - Parse response
        try {
          final responseData = jsonDecode(response.body);

          // Kiểm tra cấu trúc response
          if (responseData['message'] == 'Đăng nhập thành công.') {
            // Lấy user data từ response
            final userData = responseData['data']['user'];
            final token = responseData['data']['token'];

            // Thêm token vào userData
            userData['token'] = token;

            // Tạo User object từ JSON
            final user = User.fromJson(userData);

            print('✅ AuthAPI: Đăng nhập thành công cho user: ${user.name}');
            return user;
          } else {
            // ⭐ SỬA: Thông báo thân thiện thay vì technical message
            throw Exception('Số điện thoại hoặc mật khẩu không đúng');
          }
        } catch (e) {
          if (e.toString().contains('Exception:')) {
            rethrow; // Re-throw nếu đã là Exception
          } else {
            throw Exception('Có lỗi xảy ra. Vui lòng thử lại');
          }
        }
      } else if (response.statusCode == 401) {
        // ⭐ THÊM: Unauthorized - Thông tin đăng nhập sai
        throw Exception('Số điện thoại hoặc mật khẩu không đúng');
      } else if (response.statusCode == 404) {
        // ⭐ THÊM: Not Found - Tài khoản không tồn tại
        throw Exception('Tài khoản không tồn tại');
      } else if (response.statusCode == 403) {
        // ⭐ THÊM: Forbidden - Tài khoản bị khóa
        throw Exception('Tài khoản đã bị tạm khóa');
      } else if (response.statusCode == 429) {
        // ⭐ THÊM: Too Many Requests
        throw Exception('Bạn đã thử quá nhiều lần. Vui lòng đợi 5 phút');
      } else if (response.statusCode >= 500) {
        // ⭐ THÊM: Server Error
        throw Exception('Server đang bảo trì. Vui lòng thử lại sau');
      } else {
        // ⭐ SỬA: Các lỗi khác với thông báo đơn giản
        try {
          final errorData = jsonDecode(response.body);
          final serverMessage = errorData['message'];

          // ⭐ CHUYỂN ĐỔI MESSAGE TỪ SERVER THÀNH THÔNG BÁO THÂN THIỆN
          if (serverMessage != null) {
            if (serverMessage.toLowerCase().contains('password') ||
                serverMessage.toLowerCase().contains('mật khẩu')) {
              throw Exception('Mật khẩu không đúng');
            } else if (serverMessage.toLowerCase().contains('phone') ||
                serverMessage.toLowerCase().contains('số điện thoại')) {
              throw Exception('Số điện thoại không đúng');
            } else if (serverMessage.toLowerCase().contains('not found') ||
                serverMessage.toLowerCase().contains('không tìm thấy')) {
              throw Exception('Tài khoản không tồn tại');
            } else if (serverMessage.toLowerCase().contains('blocked') ||
                serverMessage.toLowerCase().contains('khóa')) {
              throw Exception('Tài khoản đã bị khóa');
            } else {
              throw Exception('Đăng nhập thất bại. Vui lòng thử lại');
            }
          } else {
            throw Exception('Đăng nhập thất bại. Vui lòng thử lại');
          }
        } catch (e) {
          if (e.toString().contains('Exception:')) {
            rethrow;
          } else {
            throw Exception('Đăng nhập thất bại. Vui lòng thử lại');
          }
        }
      }
    } on FormatException catch (e) {
      // ⭐ SỬA: Lỗi parse JSON với thông báo thân thiện
      print('❌ AuthAPI: JSON parse error: $e');
      throw Exception('Có lỗi xảy ra. Vui lòng thử lại');
    } on http.ClientException catch (e) {
      // ⭐ SỬA: Lỗi HTTP client với thông báo thân thiện
      print('❌ AuthAPI: HTTP client error: $e');
      throw Exception('Không thể kết nối. Kiểm tra internet');
    } catch (e) {
      // ⭐ SỬA: Xử lý các lỗi khác với thông báo thân thiện
      print('❌ AuthAPI: Exception during login: $e');

      final errorString = e.toString();

      // Nếu đã là Exception được throw từ trên, giữ nguyên message
      if (errorString.contains('Exception:')) {
        rethrow;
      }

      // ⭐ CHUYỂN ĐỔI CÁC LỖI KỸ THUẬT THÀNH THÔNG BÁO THÂN THIỆN
      if (errorString.contains('SocketException')) {
        throw Exception('Không có kết nối internet');
      } else if (errorString.contains('HandshakeException')) {
        throw Exception('Lỗi bảo mật kết nối');
      } else if (errorString.contains('TimeoutException') ||
          errorString.contains('timeout')) {
        throw Exception('Kết nối quá chậm. Vui lòng thử lại');
      } else if (errorString.contains('FormatException')) {
        throw Exception('Có lỗi xảy ra. Vui lòng thử lại');
      } else {
        throw Exception('Có lỗi xảy ra. Vui lòng thử lại');
      }
    }
  }

  // ⭐ CẬP NHẬT: Hàm register với thông báo thân thiện
  static Future<User> register({
    required String phone,
    required String password,
    required String name,
    String? email,
    String? address,
  }) async {
    try {
      print('🔄 AuthAPI: Bắt đầu đăng ký với phone: $phone');

      final url = Uri.parse('${ApiEndpoints.baseUrl}/users/register');

      final requestBody = {
        'phone': phone,
        'password': password,
        'name': name,
        if (email != null) 'email': email,
        if (address != null) 'address': address,
      };

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Kết nối quá chậm. Vui lòng thử lại');
            },
          );

      print('📥 AuthAPI: Register response status = ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final userData = responseData['data']['user'];
        final token = responseData['data']['token'];

        userData['token'] = token;
        final user = User.fromJson(userData);

        print('✅ AuthAPI: Đăng ký thành công cho user: ${user.name}');
        return user;
      } else if (response.statusCode == 409) {
        // ⭐ THÊM: Conflict - Số điện thoại đã tồn tại
        throw Exception('Số điện thoại đã được đăng ký');
      } else {
        // ⭐ SỬA: Thông báo thân thiện cho lỗi đăng ký
        throw Exception('Đăng ký thất bại. Vui lòng thử lại');
      }
    } catch (e) {
      print('❌ AuthAPI: Exception during register: $e');

      if (e.toString().contains('Exception:')) {
        rethrow;
      } else {
        throw Exception('Đăng ký thất bại. Vui lòng thử lại');
      }
    }
  }

  // Hàm logout giữ nguyên
  static Future<void> logout(String token) async {
    try {
      print('🔄 AuthAPI: Bắt đầu đăng xuất...');

      final url = Uri.parse('${ApiEndpoints.baseUrl}/users/logout');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📥 AuthAPI: Logout response status = ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ AuthAPI: Đăng xuất thành công');
      } else {
        print(
          '⚠️ AuthAPI: Đăng xuất không thành công nhưng vẫn clear local data',
        );
      }
    } catch (e) {
      print('❌ AuthAPI: Exception during logout: $e');
      // Không throw error vì logout vẫn có thể thành công ở local
    }
  }
}
