import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/models/category_model.dart';
import '../../../shared/API/api_category.dart';
import '../../../shared/widgets/widget_category.dart';
import '../../../shared/models/product_models.dart'; // Import Product model
import '../../../shared/API/api_product.dart'; // Import Product API
import '../../../shared/widgets/product_card.dart'; // Import Product card widget

// Trang Menu với StatefulWidget để quản lý state
class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

// State class cho MenuPage
class _MenuPageState extends State<MenuPage> {
  // Biến quản lý categories
  List<Category> categories = []; // Danh sách categories
  bool isLoading = true; // Trạng thái loading
  String errorMessage = ''; // Thông báo lỗi

  List<Product> products = []; // Danh sách sản phẩm
  bool isProductsLoading = true; // Trạng thái loading sản phẩm
  String productsErrorMessage = ''; // Thông báo lỗi sản phẩm
  int? selectedCategoryId; // Category được chọn

  @override
  void initState() {
    super.initState(); // Gọi hàm initState của class cha
    loadCategories(); // Load categories khi khởi tạo
  }

  // Hàm load categories từ API
  Future<void> loadCategories() async {
    try {
      setState(() {
        isLoading = true; // Bắt đầu loading
        errorMessage = ''; // Xóa lỗi cũ
      });

      // Gọi API lấy categories
      final categoryList = await ApiService.getCategories();

      print(
        '✅ MenuPage: Load thành công ${categoryList.length} categories',
      ); // Log thành công

      setState(() {
        categories = categoryList; // Lưu dữ liệu
        isLoading = false; // Tắt loading
      });

      // ⭐ THÊM PHẦN NÀY: Tự động load products của category đầu tiên
      if (categories.isNotEmpty) {
        await loadProductsByCategory(
          categories[0].id,
        ); // Load products của category index 0
      }
    } catch (e) {
      print('❌ MenuPage: Lỗi load categories: $e'); // Log lỗi

      setState(() {
        errorMessage = e.toString(); // Lưu thông báo lỗi
        isLoading = false; // Tắt loading
      });
    }
  }

  // Hàm load products theo category ID
  Future<void> loadProductsByCategory(int categoryId) async {
    try {
      print(
        '🔄 MenuPage: Bắt đầu load products cho category $categoryId...',
      ); // Log debug

      setState(() {
        isProductsLoading = true; // Bắt đầu loading products
        productsErrorMessage = ''; // Xóa lỗi cũ
        selectedCategoryId = categoryId; // Lưu category được chọn
      });

      // Gọi API lấy products theo category
      final productList = await ProductApiService.getProductsByCategory(
        categoryId,
      );

      print(
        '✅ MenuPage: Load thành công ${productList.length} products',
      ); // Log thành công

      setState(() {
        products = productList; // Lưu dữ liệu products
        isProductsLoading = false; // Tắt loading
      });
    } catch (e) {
      print('❌ MenuPage: Lỗi load products: $e'); // Log lỗi

      setState(() {
        productsErrorMessage = e.toString(); // Lưu thông báo lỗi
        isProductsLoading = false; // Tắt loading
      });
    }
  }

  // Hàm refresh tất cả dữ liệu
  Future<void> refreshAllData() async {
    await loadCategories(); // Load lại categories

    // Nếu đã chọn category, load lại products
    if (selectedCategoryId != null) {
      await loadProductsByCategory(selectedCategoryId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menu',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.darkGreen,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),

      body: RefreshIndicator(
        onRefresh:
            refreshAllData, // Thay đổi từ loadCategories thành refreshAllData
        child: Column(
          // ⭐ THAY ĐỔI: Từ SingleChildScrollView thành Column
          children: [
            // PHẦN 1: Categories (cố định ở trên)
            Container(
              color: AppColors.white,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child:
                        _buildCategoriesSection(), // Categories horizontal scroll
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 1, color: AppColors.lightCream),
                ],
              ),
            ),

            // PHẦN 2: Products (cuộn được) - ⭐ THÊM PHẦN NÀY
            Expanded(
              // Chiếm hết không gian còn lại
              child:
                  _buildProductsSection(), // ✅ SỬ DỤNG _buildProductsSection() ở đây!
            ),
          ],
        ),
      ),
    );
  }

  // Hàm private tạo phần categories
  Widget _buildCategoriesSection() {
    // Kiểm tra nếu đang loading
    if (isLoading) {
      return const Center(
        // Căn giữa
        child: Column(
          // Cột chứa loading indicator và text
          children: [
            CircularProgressIndicator(
              // Loading indicator tròn
              color: AppColors.gray, // Màu xám
            ),
            SizedBox(height: 16), // Khoảng cách 16px
            Text(
              'Đang tải danh mục...', // Text loading
              style: TextStyle(
                color: AppColors.brown, // Màu nâu
                fontSize: 16, // Cỡ chữ 16
              ),
            ),
          ],
        ),
      );
    }

    // Kiểm tra nếu có lỗi
    if (errorMessage.isNotEmpty) {
      return Center(
        // Căn giữa
        child: Column(
          // Cột chứa các phần tử lỗi
          mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo trục dọc
          children: [
            const Icon(
              Icons.error_outline, // Icon lỗi
              size: 60, // Kích thước 60px
              color: AppColors.brown, // Màu nâu
            ),
            const SizedBox(height: 16), // Khoảng cách 16px
            Text(
              'Lỗi: $errorMessage', // Hiển thị thông báo lỗi
              style: const TextStyle(
                color: AppColors.brown, // Màu nâu
                fontSize: 16, // Cỡ chữ 16
              ),
              textAlign: TextAlign.center, // Căn giữa text
            ),
            const SizedBox(height: 16), // Khoảng cách 16px
            ElevatedButton(
              // Button thử lại
              onPressed: loadCategories, // Gọi lại hàm load
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gray, // Màu nền cam
                foregroundColor: AppColors.white, // Màu chữ trắng
                padding: const EdgeInsets.symmetric(
                  // Padding button
                  horizontal: 24, // Trái phải 24px
                  vertical: 12, // Trên dưới 12px
                ),
              ),
              child: const Text('Thử lại'), // Text trên button
            ),
          ],
        ),
      );
    }

    // Kiểm tra nếu danh sách rỗng
    if (categories.isEmpty) {
      return Center(
        // Căn giữa
        child: Column(
          // Cột chứa icon và text
          children: [
            const Icon(
              Icons.restaurant, // Icon nhà hàng
              size: 60, // Kích thước 60px
              color: AppColors.brown, // Màu nâu
            ),
            const SizedBox(height: 16), // Khoảng cách 16px
            const Text(
              'Không có danh mục nào', // Text thông báo
              style: TextStyle(
                color: AppColors.brown, // Màu nâu
                fontSize: 16, // Cỡ chữ 16
              ),
            ),
          ],
        ),
      );
    }

    // Trả về UI chính khi có dữ liệu
    return Column(
      // Cột chứa header và grid
      crossAxisAlignment: CrossAxisAlignment.start, // Căn trái
      children: [
        // Header với title
        Row(
          // Hàng ngang
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn đều hai đầu
          children: [
            const Text(
              'Danh mục món ăn', // Tiêu đề
              style: TextStyle(
                fontSize: 20, // Cỡ chữ 20
                fontWeight: FontWeight.bold, // Chữ đậm
                color: AppColors.brown, // Màu nâu
              ),
            ),
            Text(
              '${categories.length} danh mục', // Số lượng danh mục
              style: const TextStyle(
                fontSize: 14, // Cỡ chữ 14
                color: AppColors.darkGreen, // Màu xanh đậm
                fontWeight: FontWeight.w500, // Chữ vừa đậm
              ),
            ),
          ],
        ),

        const SizedBox(height: 16), // Khoảng cách 16px
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected =
                  selectedCategoryId ==
                  category.id; // ⭐ THÊM: Kiểm tra category được chọn

              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    print('Đã chọn: ${category.name}');
                    loadProductsByCategory(category.id);
                  },
                  child: Container(
                    // ⭐ THÊM: Container wrapper để highlight
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? AppColors.darkGreen
                            : Colors.transparent, // Border cam nếu được chọn
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CategoryCard(category: category),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  //Hàm tạo Product
  Widget _buildProductsSection() {
    if (selectedCategoryId == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 60, color: AppColors.accent),
            SizedBox(height: 16),
            Text(
              'Vui lòng chọn một danh mục',
              style: TextStyle(color: AppColors.brown),
            ),
          ],
        ),
      );
    }
    // Kiểm tra nếu đang loading products
    if (isProductsLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.gray),
            SizedBox(height: 16),
            Text(
              'Đang tải sản phẩm...',
              style: TextStyle(fontSize: 16, color: AppColors.brown),
            ),
          ],
        ),
      );
    }

    // Kiểm tra nếu có lỗi loading products
    if (productsErrorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: AppColors.brown),
              const SizedBox(height: 16),
              const Text(
                'Không thể tải sản phẩm',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.brown,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                productsErrorMessage,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.darkGreen,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => loadProductsByCategory(selectedCategoryId!),
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

    // Kiểm tra nếu danh sách products rỗng
    if (products.isEmpty) {
      // Tìm tên category
      final categoryName = categories
          .firstWhere(
            (cat) => cat.id == selectedCategoryId,
            orElse: () => Category(id: 0, name: 'Không xác định', image: ''),
          )
          .name;

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant,
              size: 60,
              color: AppColors.brown.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Chưa có sản phẩm nào',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.brown,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Danh mục "$categoryName" đang được cập nhật',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.brown.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    return Column(
      children: [
        Container(
          width: double.infinity, //Ngang full
          padding: const EdgeInsets.all(16), //căn lề tất cả cấc hướng
          color: AppColors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, //căn đối diện
            children: [
              Text(
                'Sản Phẩm',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.brown,
                ),
              ),
            ],
          ),
        ),
        //Product List Grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, //2 cột
                childAspectRatio: 0.75, // tỉ lệ width/height = 0.75
                crossAxisSpacing: 12, //khoản cách giữa cácc cột
                mainAxisSpacing: 12, //khoản cách giữa các hàng
              ),

              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    _onProductTap(product);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _onProductTap(Product product) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildProductDetailBottomSheet(product),
    );
  }

  Widget _buildProductDetailBottomSheet(Product product) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.brown.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Nội dung
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên product
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.brown,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Mô tả product
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.darkGreen,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Danh sách giá (nếu có nhiều options)
                  if (product.productDetails.isNotEmpty) ...[
                    const Text(
                      'Tùy chọn:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.brown,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Danh sách options
                    ...product.productDetails
                        .map(
                          (detail) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  detail.size ?? 'Mặc định',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.brown,
                                  ),
                                ),
                                Text(
                                  detail.formattedPrice,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.gray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ],

                  const Spacer(),

                  // Button thêm vào giỏ hàng
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);

                        // Hiển thị snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Đã thêm "${product.name}" vào giỏ hàng',
                            ),
                            backgroundColor: AppColors.gray,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gray,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Thêm vào giỏ hàng',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
}
