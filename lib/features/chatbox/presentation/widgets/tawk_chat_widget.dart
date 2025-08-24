import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/tawk_service.dart';

// Widget chứa Tawk.to WebView
class TawkChatWidget extends StatefulWidget {
  const TawkChatWidget({super.key});

  @override
  State<TawkChatWidget> createState() => _TawkChatWidgetState();
}

class _TawkChatWidgetState extends State<TawkChatWidget> {
  late final WebViewController _controller;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    try {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setUserAgent(
          'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36',
        )
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              print('🔄 Loading URL: $url');
              if (mounted) {
                setState(() {
                  isLoading = true;
                  hasError = false;
                });
              }
            },

            onPageFinished: (String url) {
              print('✅ Page loaded: $url');
              if (mounted) {
                setState(() {
                  isLoading = false;
                });
              }

              // Inject custom CSS để full screen
              _injectCustomStyles();
            },

            onWebResourceError: (WebResourceError error) {
              print('❌ WebView error: ${error.description}');
              if (mounted) {
                setState(() {
                  isLoading = false;
                  hasError = true;
                  errorMessage = error.description;
                });
              }
            },
          ),
        );

      // ⭐ THAY ĐỔI: Load trực tiếp URL Tawk.to thay vì HTML string
      _loadTawkDirectly();
    } catch (e) {
      print('❌ Error initializing WebView: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
          hasError = true;
          errorMessage = e.toString();
        });
      }
    }
  }

  // ⭐ MỚI: Load trực tiếp Tawk.to URL
  void _loadTawkDirectly() {
    final tawkUrl =
        'https://tawk.to/chat/${TawkService.propertyId}/${TawkService.widgetId}';
    print('🔗 Loading Tawk.to directly: $tawkUrl');
    _controller.loadRequest(Uri.parse(tawkUrl));
  }

  // Inject CSS để làm fullscreen
  void _injectCustomStyles() {
    const jsCode = '''
      // Remove default margins and make fullscreen
      document.body.style.margin = '0';
      document.body.style.padding = '0';
      document.body.style.overflow = 'hidden';
      
      // Find and style Tawk widget
      const tawkWidget = document.querySelector('#tawkchat-container, .tawk-widget, [id*="tawk"]');
      if (tawkWidget) {
        tawkWidget.style.position = 'fixed';
        tawkWidget.style.top = '0';
        tawkWidget.style.left = '0';
        tawkWidget.style.width = '100%';
        tawkWidget.style.height = '100%';
        tawkWidget.style.zIndex = '9999';
        console.log('✅ Tawk widget styled for fullscreen');
      }
      
      // Hide any potential headers or navigation
      const headers = document.querySelectorAll('header, nav, .header, .navigation');
      headers.forEach(header => header.style.display = 'none');
      
      // Maximize chat if possible
      setTimeout(() => {
        if (typeof Tawk_API !== 'undefined' && Tawk_API.maximize) {
          try {
            Tawk_API.maximize();
            console.log('✅ Chat maximized');
          } catch (e) {
            console.log('⚠️ Could not maximize chat');
          }
        }
      }, 2000);
    ''';

    _controller.runJavaScript(jsCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // WebView chính
          if (!hasError) WebViewWidget(controller: _controller),

          // Loading overlay
          if (isLoading && !hasError)
            Container(
              color: AppColors.gray,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 60,
                      color: AppColors.white,
                    ),
                    SizedBox(height: 24),
                    CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Đang kết nối hỗ trợ...',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Error state
          if (hasError)
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.support_agent,
                      size: 80,
                      color: AppColors.gray,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Dịch vụ hỗ trợ tạm thời không khả dụng',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.brown,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Vui lòng thử lại sau hoặc liên hệ qua:',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.darkGreen,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Alternative contact methods
                    _buildAlternativeContacts(),

                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          hasError = false;
                          isLoading = true;
                        });
                        _loadTawkDirectly();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Thử lại'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gray,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Widget hiển thị các cách liên hệ thay thế
  Widget _buildAlternativeContacts() {
    return Column(
      children: [
        _buildContactItem(
          icon: Icons.phone,
          title: 'Hotline',
          subtitle: '1900 1234',
          onTap: () {
            // TODO: Implement phone call
            print('Call hotline');
          },
        ),
        const SizedBox(height: 12),
        _buildContactItem(
          icon: Icons.email,
          title: 'Email',
          subtitle: 'support@fastfood.app',
          onTap: () {
            // TODO: Implement email
            print('Send email');
          },
        ),
        const SizedBox(height: 12),
        _buildContactItem(
          icon: Icons.facebook,
          title: 'Facebook',
          subtitle: 'FastFood Support',
          onTap: () {
            // TODO: Implement Facebook link
            print('Open Facebook');
          },
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightCream),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.gray),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.brown,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.darkGreen,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.darkGreen,
            ),
          ],
        ),
      ),
    );
  }
}
