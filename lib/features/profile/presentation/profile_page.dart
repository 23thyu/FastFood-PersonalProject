import 'package:flutter/material.dart';
import 'package:fastfood_app/core/constants/app_colors.dart';
import 'package:fastfood_app/features/login_register/domain/user_model.dart';
import 'package:fastfood_app/features/login_register/presentation/login_page.dart';

// Trang Profile
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.user});
  final User user; // nhận user từ ngoài vào
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  //tạo hàm Appbar
  Widget _buildAppBar() {
    return Container(
      color: AppColors.darkGreen, // màu nền
      padding: const EdgeInsets.only(top: 48, left: 20, right: 20, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 31,
                backgroundColor: AppColors.lightCream,
                backgroundImage:
                    widget.user.avatar != null && widget.user.avatar!.isNotEmpty
                    ? NetworkImage(widget.user.avatar!)
                    : null,
                child: widget.user.avatar == null || widget.user.avatar!.isEmpty
                    ? const Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.darkGreen,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.user.phone ?? "",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
          const SizedBox(height: 16),
          // 2.3. Thông tin điểm và ví
          Row(
            children: [
              // 2.3.1. DRIPS
              Row(
                children: [
                  const Icon(Icons.stars, color: AppColors.white, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    "DRIPS: 0",
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              // 2.3.2. Trả trước
              Row(
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    color: AppColors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Trả Trước: 0 ₫",
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // 2.3.3. Nút kích hoạt (nếu cần)
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightCream,
                  foregroundColor: AppColors.darkGreen,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "KÍCH HOẠT",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      color: AppColors.lightCream,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Add your widgets here
                _buildSectionTitle("Thông Tin Chung"),
                _buildMenuItem(Icons.description, "Điều khoản dịch vụ", () {}),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: () async {
                // Nếu bạn có lưu user ở local, hãy xóa ở đây (ví dụ với SharedPreferences):
                // final prefs = await SharedPreferences.getInstance();
                // await prefs.clear();

                // Chuyển về LoginPage và xóa hết stack
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkGreen,
                foregroundColor: AppColors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                "ĐĂNG XUẤT",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.darkGreen,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppColors.darkGreen),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(color: AppColors.darkGreen, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
