// Import các thư viện và file cần thiết
import 'package:fastfood_app/features/menu/presentation/menu_page.dart';
import 'package:flutter/material.dart' hide Banner;
import '../../../core/constants/app_colors.dart';
import '../../../shared/models/category_model.dart';
import '../../../shared/API/api_category.dart';
import '../../../shared/widgets/widget_category.dart';
// Import thêm cho Banner
import '../../homepage/domain/banner_models.dart'; // Model Banner (use the same as everywhere else)
import '../../../shared/widgets/banner_widget.dart'; // Widget Banner
import '../data/api_banner.dart';

// Class HomePage kế thừa từ StatefulWidget
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

// State class chứa logic và UI
class _HomePageState extends State<HomePage> {
  // Biến cho Categories
  List<Category> categories = []; // Danh sách categories
  bool isCategoriesLoading = true; // Trạng thái loading categories
  String categoriesErrorMessage = ''; // Thông báo lỗi categories

  // Biến cho Banners
  List<Banner> banners =
      []; // Danh sách banners (from homepage/domain/banner_models.dart)
  bool isBannersLoading = true; // Trạng thái loading banners
  String bannersErrorMessage = ''; // Thông báo lỗi banners

  @override
  void initState() {
    super.initState(); // Gọi hàm initState của class cha

    // Load cả categories và banners khi khởi tạo
    loadCategories(); // Load categories
    loadBanners(); // Load banners
  }

  // Hàm load categories (giữ nguyên như cũ)
  Future<void> loadCategories() async {
    try {
      setState(() {
        isCategoriesLoading = true; // Bắt đầu loading
        categoriesErrorMessage = ''; // Xóa lỗi cũ
      });

      // Gọi API lấy categories
      final categoryList = await ApiService.getCategories();

      setState(() {
        categories = categoryList; // Lưu dữ liệu
        isCategoriesLoading = false; // Tắt loading
      });
    } catch (e) {
      setState(() {
        categoriesErrorMessage = e.toString(); // Lưu thông báo lỗi
        isCategoriesLoading = false; // Tắt loading
      });
    }
  }

  // Hàm load banners (mới)
  Future<void> loadBanners() async {
    try {
      print('🔄 Bắt đầu load banners...'); // Log debug

      setState(() {
        isBannersLoading = true; // Bắt đầu loading
        bannersErrorMessage = ''; // Xóa lỗi cũ
      });

      // Gọi API lấy banners
      final bannerList = await BannerApiService.getBanners();

      print(
        '✅ Load banners thành công: ${bannerList.length} banners',
      ); // Log thành công

      setState(() {
        banners = bannerList; // Lưu danh sách banners
        isBannersLoading = false; // Tắt loading
      });
    } catch (e) {
      print('❌ Lỗi load banners: $e'); // Log lỗi

      setState(() {
        bannersErrorMessage = e.toString(); // Lưu thông báo lỗi
        isBannersLoading = false; // Tắt loading
      });
    }
  }

  // Hàm refresh tất cả dữ liệu
  Future<void> refreshAllData() async {
    // Chạy song song cả 2 API calls
    await Future.wait([
      loadCategories(), // Load categories
      loadBanners(), // Load banners
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.darkGreen,
        centerTitle: true,
      ),

      // Body
      body: RefreshIndicator(
        onRefresh: refreshAllData, // Hàm refresh tất cả dữ liệu
        child: SingleChildScrollView(
          // Cho phép cuộn dọc
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24), // Khoảng cách
              // PHẦN 2: Banners Section (MỚI)
              _buildBannersSection(),

              const SizedBox(height: 24), // Khoảng cách
              // PHẦN 3: Categories Section (giữ nguyên)
              _buildCategoriesSection(),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm tạo phần banners (MỚI)
  Widget _buildBannersSection() {
    // Kiểm tra nếu đang loading banners
    if (isBannersLoading) {
      return Container(
        height: 180, // Chiều cao như banner
        decoration: BoxDecoration(
          color: AppColors.lightCream, // Màu nền
          borderRadius: BorderRadius.circular(15), // Bo góc
        ),
        child: const Center(
          // Căn giữa
          child: CircularProgressIndicator(
            // Loading indicator
            color: AppColors.gray, // Màu cam
          ),
        ),
      );
    }

    // Kiểm tra nếu có lỗi loading banners
    if (bannersErrorMessage.isNotEmpty) {
      return Container(
        height: 180, // Chiều cao như banner
        decoration: BoxDecoration(
          color: AppColors.lightCream, // Màu nền
          borderRadius: BorderRadius.circular(15), // Bo góc
        ),
        child: Center(
          // Căn giữa
          child: Column(
            // Cột chứa icon và text
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline, // Icon lỗi
                color: AppColors.brown,
                size: 40,
              ),
              const SizedBox(height: 8),
              Text(
                'Lỗi tải banners', // Text thông báo
                style: const TextStyle(color: AppColors.brown, fontSize: 14),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                // Button thử lại
                onPressed: loadBanners, // Gọi lại hàm load banners
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gray,
                  foregroundColor: AppColors.white,
                ),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    // Kiểm tra nếu danh sách banners rỗng
    if (banners.isEmpty) {
      return Container(
        height: 180, // Chiều cao như banner
        decoration: BoxDecoration(
          color: AppColors.lightCream, // Màu nền
          borderRadius: BorderRadius.circular(15), // Bo góc
        ),
        child: const Center(
          // Căn giữa
          child: Text(
            'Không có banner nào', // Text thông báo
            style: TextStyle(color: AppColors.brown, fontSize: 16),
          ),
        ),
      );
    }

    // Trả về BannerCarousel khi có dữ liệu
    return BannerCarousel(banners: banners);
  }

  // Hàm tạo phần categories (giữ nguyên như cũ)
  Widget _buildCategoriesSection() {
    if (isCategoriesLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.gray),
      );
    }

    if (categoriesErrorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: AppColors.brown),
            const SizedBox(height: 16),
            Text(
              'Lỗi: $categoriesErrorMessage',
              style: const TextStyle(color: AppColors.brown, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loadCategories,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gray,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (categories.isEmpty) {
      return const Center(
        child: Text(
          'Không có danh mục nào',
          style: TextStyle(color: AppColors.brown, fontSize: 16),
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.brown,
              ),
            ),
            GestureDetector(
              onTap: () {
                //điều hướng đến Menu Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MenuPage()),
                );
              },
              child: const Text(
                'Xem tất cả',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGreen,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    print('Đã chọn: ${categories[index].name}');
                  },
                  child: CategoryCard(category: categories[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
