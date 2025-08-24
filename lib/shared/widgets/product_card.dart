// Import thư viện cần thiết
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart'; // Import màu sắc
import '../../shared/models/product_models.dart'; // Import Product model

//Tạo một widget hiển thị một product card
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  // Constructor
  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    final minPrice = product.productDetails.isNotEmpty
        ? product.productDetails
              .map((e) => e.price)
              .reduce((a, b) => a < b ? a : b)
        : 0; // Lấy giá nhỏ nhất từ product details

    return GestureDetector(
      //widget bắt sự kiện khi ấn
      onTap: onTap, //CALL BACK khi ấn
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), //bo góc
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4, //độ mờ
              offset: Offset(0, 2), //vị trí bóng
            ),
          ],
        ),
        child: Column(
          //chưa các phần tử
          crossAxisAlignment: CrossAxisAlignment.start, //Căn trái
          children: [
            //Phần hình ảnh
            Expanded(
              // Chiếm hết không gian còn lại
              flex: 3, // Tỷ lệ 3/5 của card
              child: Container(
                width: double.infinity, // Chiều rộng full
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    // Bo góc chỉ phía trên
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  color: AppColors.lightCream, // Màu nền khi loading
                ),
                child: ClipRRect(
                  // Widget bo góc cho hình ảnh
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.network(
                    // Widget hiển thị hình ảnh từ URL
                    product.image, // URL hình ảnh
                    fit: BoxFit.cover, // Hiển thị đầy đủ, có thể cắt
                    // Widget loading khi đang tải hình
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child; // Đã tải xong

                      return Container(
                        // Container loading
                        color: AppColors.lightCream,
                        child: const Center(
                          child: CircularProgressIndicator(
                            // Loading indicator
                            color: AppColors.primary,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },

                    // Widget hiển thị khi lỗi
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.lightCream,
                        child: const Center(
                          child: Column(
                            // Cột chứa icon và text lỗi
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_not_supported_outlined, // Icon lỗi
                                color: AppColors.brown,
                                size: 30,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Không có ảnh', // Text lỗi
                                style: TextStyle(
                                  color: AppColors.brown,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            //Phần 2/5 còn lại
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Padding cho phần này
                child: Column(
                  //cột chưa tên và giá trrị
                  crossAxisAlignment: CrossAxisAlignment.start, //căng bên trái
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //căn điều
                  children: [
                    //Tên sản phẩm
                    Text(
                      product.name, // Tên sản phẩm
                      style: const TextStyle(
                        fontSize: 14, // Cỡ chữ 14
                        fontWeight: FontWeight.w600, // Chữ đậm vừa
                        color: AppColors.brown, // Màu nâu
                      ),
                      maxLines: 2, // Tối đa 2 dòng
                      overflow: TextOverflow.ellipsis, // Cắt text dài
                    ),
                    //phần giá và nút thêm
                    Row(
                      children: [
                        Expanded(
                          //cái này chiếm hết các không gian còn lại
                          child: Text(
                            minPrice > 0
                                ? '${minPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ' // Format giá tiền
                                : 'Liên hệ', // Nếu không có giá
                            style: const TextStyle(
                              fontSize: 13, // Cỡ chữ 13
                              fontWeight: FontWeight.bold, // Chữ đậm
                              color: AppColors.gray, // Màu cam
                            ),
                          ),
                        ),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.primary, // Màu nền nút
                            borderRadius: BorderRadius.circular(14), // Bo tròn
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
