// Model cho sản phẩm/món ăn
class Product {
  final int id; // ID sản phẩm
  final String name; // Tên sản phẩm
  final String description; // Mô tả sản phẩm
  final String image; // URL hình ảnh
  final int brandId; // ID thương hiệu
  final int categoryId; // ID danh mục
  final String createdAt; // Ngày tạo
  final String updatedAt; // Ngày cập nhật
  final List<ProductDetail> productDetails; // Chi tiết sản phẩm (giá, size...)

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.brandId,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.productDetails,
  });

  // Chuyển từ JSON sang Product object
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      brandId: json['brand_id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      productDetails:
          (json['product_details'] as List<dynamic>?)
              ?.map((detail) => ProductDetail.fromJson(detail))
              .toList() ??
          [],
    );
  }
}

// Model cho chi tiết sản phẩm (giá, size...)
class ProductDetail {
  final int price; // Giá sản phẩm
  final String? size; // Size (nếu có)
  final String? type; // Loại (nếu có)

  ProductDetail({required this.price, this.size, this.type});

  // Chuyển từ JSON sang ProductDetail object
  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      price: json['price'] ?? 0,
      size: json['size'],
      type: json['type'],
    );
  }

  // Format giá tiền
  String get formattedPrice {
    return '${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ';
  }
}
