// Model để lưu thông tin user sau khi đăng nhập thành công
class User {
  final int id; // ID của user
  final String? email; // Email user (nullable)
  final String name; // Tên user
  final String? phone; // Số điện thoại (nullable)
  final String? address; // Địa chỉ (nullable)
  final String? avatar; // URL avatar (nullable)
  final int role; // Vai trò: 0=user, 1=admin, 2=staff
  final String token; // JWT token để authenticate
  final DateTime? createdAt; // Ngày tạo tài khoản
  final DateTime? updatedAt; // Ngày cập nhật cuối

  // Constructor với required và optional parameters
  User({
    required this.id, // Bắt buộc có ID
    this.email, // Có thể null
    required this.name, // Bắt buộc có tên
    this.phone, // Có thể null
    this.address, // Có thể null
    this.avatar, // Có thể null
    required this.role, // Bắt buộc có role
    required this.token, // Bắt buộc có token
    this.createdAt, // Có thể null
    this.updatedAt, // Có thể null
  });

  // Factory constructor để tạo User từ JSON response của API
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0, // Lấy id, default = 0 nếu null
      email: json['email'], // Lấy email, có thể null
      name: json['name'] ?? '', // Lấy name, default = '' nếu null
      phone: json['phone'], // Lấy phone, có thể null
      address: json['address'], // Lấy address, có thể null
      avatar: json['avatar'], // Lấy avatar, có thể null
      role: json['role'] ?? 0, // Lấy role, default = 0 nếu null
      token: json['token'] ?? '', // Lấy token, default = '' nếu null
      // Parse string thành DateTime, null nếu không có
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  // Method để convert User object thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Convert id
      'email': email, // Convert email
      'name': name, // Convert name
      'phone': phone, // Convert phone
      'address': address, // Convert address
      'avatar': avatar, // Convert avatar
      'role': role, // Convert role
      'token': token, // Convert token
      'createdAt': createdAt
          ?.toIso8601String(), // Convert DateTime thành string
      'updatedAt': updatedAt
          ?.toIso8601String(), // Convert DateTime thành string
    };
  }
}
