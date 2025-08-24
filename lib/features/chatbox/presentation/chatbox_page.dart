import 'package:flutter/material.dart';
import 'package:fastfood_app/core/constants/app_colors.dart';
import 'widgets/tawk_chat_widget.dart'; // Import TawkChatWidget

// Trang ChatBox với Tawk.to integration - Trực tiếp hiển thị chat
class ChatBoxPage extends StatefulWidget {
  const ChatBoxPage({super.key});

  @override
  State<ChatBoxPage> createState() => _ChatBoxPageState();
}

class _ChatBoxPageState extends State<ChatBoxPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: const Text(
          'Hỗ trợ khách hàng',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.darkGreen,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.white),
        // Thêm action button để refresh chat nếu cần
        actions: [
          IconButton(
            onPressed: () {
              // Reload trang bằng cách pop và push lại
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const ChatBoxPage()),
              );
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Làm mới chat',
          ),
        ],
      ),

      // Body - Trực tiếp hiển thị TawkChatWidget
      body: const TawkChatWidget(),
    );
  }
}
