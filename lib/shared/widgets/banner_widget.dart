// Import các thư viện cần thiết
import 'package:flutter/material.dart' hide Banner; // Thư viện Flutter UI
import '../../core/constants/app_colors.dart'; // Import màu sắc app
import '../../features/homepage/domain/banner_models.dart'; // Import Banner model

// Widget để hiển thị một banner card
class BannerCard extends StatelessWidget {
  // Biến banner để nhận dữ liệu từ bên ngoài
  final Banner banner;

  // Constructor nhận tham số banner bắt buộc
  const BannerCard({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    // Container chính chứa toàn bộ banner
    return Container(
      // Đặt margin (khoảng cách bên ngoài) cho container
      margin: const EdgeInsets.symmetric(horizontal: 8.0),

      // Trang trí cho container
      decoration: BoxDecoration(
        color: AppColors.white, // Màu nền trắng
        borderRadius: BorderRadius.circular(15), // Bo góc 15px
        boxShadow: [
          // Hiệu ứng bóng đổ
          BoxShadow(
            color: Colors.grey.withOpacity(
              0.3,
            ), // Màu bóng xám với độ trong suốt 30%
            blurRadius: 8, // Độ mờ của bóng
            offset: const Offset(0, 3), // Vị trí bóng (x: 0, y: 3)
          ),
        ],
      ),

      // Widget con bên trong container
      child: ClipRRect(
        // Widget để bo góc cho hình ảnh
        borderRadius: BorderRadius.circular(15), // Bo góc 15px
        child: Image.network(
          // Widget hiển thị hình ảnh từ URL
          banner.image, // URL hình ảnh từ API
          width: double.infinity, // Chiều rộng full container
          height: 180, // Chiều cao cố định 180px
          fit: BoxFit.cover, // Hiển thị hình ảnh đầy đủ, có thể cắt bớt
          // Widget hiển thị khi đang tải hình ảnh
          loadingBuilder: (context, child, loadingProgress) {
            // Nếu đã tải xong, hiển thị hình ảnh
            if (loadingProgress == null) return child;

            // Nếu đang tải, hiển thị loading indicator
            return Container(
              width: double.infinity, // Chiều rộng full
              height: 180, // Chiều cao như hình ảnh
              color: AppColors.lightCream, // Màu nền khi loading
              child: const Center(
                // Căn giữa
                child: CircularProgressIndicator(
                  // Biểu tượng loading tròn
                  color: AppColors.gray, // Màu cam
                ),
              ),
            );
          },

          // Widget hiển thị khi có lỗi tải hình ảnh
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity, // Chiều rộng full
              height: 180, // Chiều cao như hình ảnh
              color: AppColors.lightCream, // Màu nền
              child: const Column(
                // Cột chứa icon và text
                mainAxisAlignment:
                    MainAxisAlignment.center, // Căn giữa theo trục dọc
                children: [
                  Icon(
                    Icons.error_outline, // Icon lỗi
                    color: AppColors.brown, // Màu nâu
                    size: 40, // Kích thước 40px
                  ),
                  SizedBox(height: 8), // Khoảng cách 8px
                  Text(
                    'Không thể tải hình ảnh', // Text thông báo lỗi
                    style: TextStyle(
                      color: AppColors.brown, // Màu nâu
                      fontSize: 14, // Cỡ chữ 14
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Widget để hiển thị carousel (băng chuyền) banners
class BannerCarousel extends StatefulWidget {
  // Danh sách banners để hiển thị
  final List<Banner> banners;

  // Constructor nhận danh sách banners
  const BannerCarousel({super.key, required this.banners});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

// State class cho BannerCarousel
class _BannerCarouselState extends State<BannerCarousel> {
  // Controller để điều khiển PageView
  late PageController _pageController;

  // Index của banner hiện tại
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState(); // Gọi hàm initState của class cha

    // Khởi tạo PageController
    _pageController = PageController();

    // Tự động chuyển banner sau mỗi 3 giây
    _startAutoSlide();
  }

  // Hàm tự động chuyển banner
  void _startAutoSlide() {
    // Tạo timer lặp lại mỗi 3 giây
    Future.delayed(const Duration(seconds: 3), () {
      // Kiểm tra xem widget còn tồn tại không
      if (mounted && widget.banners.isNotEmpty) {
        // Tính index tiếp theo (quay vòng về 0 nếu đến cuối)
        int nextIndex = (_currentIndex + 1) % widget.banners.length;

        // Chuyển đến trang tiếp theo với animation
        _pageController.animateToPage(
          nextIndex, // Trang đích
          duration: const Duration(
            milliseconds: 300,
          ), // Thời gian animation 300ms
          curve: Curves.easeInOut, // Kiểu animation mượt mà
        );

        // Gọi lại hàm này để tiếp tục auto slide
        _startAutoSlide();
      }
    });
  }

  @override
  void dispose() {
    // Hủy PageController khi widget bị destroy để tránh memory leak
    _pageController.dispose();
    super.dispose(); // Gọi hàm dispose của class cha
  }

  @override
  Widget build(BuildContext context) {
    // Kiểm tra nếu danh sách banners rỗng
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink(); // Trả về widget rỗng
    }

    // Column chứa PageView và indicators
    return Column(
      children: [
        // Container chứa PageView
        Container(
          height: 180, // Chiều cao cố định
          width: double.infinity, // Chiều rộng full màn hình
          child: PageView.builder(
            // Widget tạo các trang có thể vuốt
            controller: _pageController, // Gán controller
            onPageChanged: (index) {
              // Callback khi chuyển trang
              setState(() {
                _currentIndex = index; // Cập nhật index hiện tại
              });
            },
            itemCount: widget.banners.length, // Số lượng trang
            itemBuilder: (context, index) {
              // Hàm tạo từng trang
              return GestureDetector(
                // Widget bắt sự kiện touch
                onTap: () {
                  // Callback khi nhấn vào banner
                  print('Banner được nhấn: ${widget.banners[index].name}');
                  // TODO: Navigate to banner detail or promotion page
                },
                child: BannerCard(
                  // Hiển thị banner card
                  banner: widget.banners[index], // Truyền dữ liệu banner
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12), // Khoảng cách 12px
        // Indicators (chấm tròn hiển thị vị trí hiện tại)
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Căn giữa
          children: List.generate(
            // Tạo danh sách widget
            widget.banners.length, // Số lượng = số banners
            (index) => Container(
              // Mỗi chấm tròn
              width: 8, // Chiều rộng 8px
              height: 8, // Chiều cao 8px
              margin: const EdgeInsets.symmetric(
                horizontal: 4,
              ), // Margin trái phải 4px
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Hình tròn
                color:
                    _currentIndex ==
                        index // Màu sắc conditional
                    ? AppColors
                          .gray // Màu cam nếu là trang hiện tại
                    : AppColors.brown.withOpacity(
                        0.3,
                      ), // Màu nâu nhạt nếu không phải
              ),
            ),
          ),
        ),
      ],
    );
  }
}
