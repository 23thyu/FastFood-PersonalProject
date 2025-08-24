import 'package:flutter/material.dart';
import 'package:fastfood_app/core/constants/app_colors.dart';

// Trang Profile
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.gray,
        elevation: 0,
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Profile Page',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.brown,
          ),
        ),
      ),
    );
  }
}
