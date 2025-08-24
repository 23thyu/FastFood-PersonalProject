import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/category_model.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hình ảnh category
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              category.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: AppColors.lightCream,
                  child: const Icon(
                    Icons.restaurant_menu,
                    color: AppColors.gray,
                    size: 30,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Tên category
          Text(
            category.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.brown,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
