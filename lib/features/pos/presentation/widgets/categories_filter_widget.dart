import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../menu/presentation/bloc/category/category_bloc.dart';
import '../../../menu/presentation/bloc/category/category_event.dart';
import '../../../menu/presentation/bloc/category/category_state.dart';
import '../../../menu/presentation/bloc/product/product_bloc.dart';
import '../../../menu/presentation/bloc/product/product_event.dart';

class CategoriesFilterWidget extends StatefulWidget {
  const CategoriesFilterWidget({super.key});

  @override
  State<CategoriesFilterWidget> createState() => _CategoriesFilterWidgetState();
}

class _CategoriesFilterWidgetState extends State<CategoriesFilterWidget> {
  int? _selectedCategoryId; // null يعني "الكل"

  @override
  void initState() {
    super.initState();
    // جلب التصنيفات بمجرد تحميل المكون
    context.read<CategoryBloc>().add(GetCategoriesEvent());
  }

  void _onCategorySelected(int? categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
    // توجيه أمر لجلب منتجات هذا التصنيف
    context.read<ProductBloc>().add(GetProductsEvent(categoryId: categoryId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const SizedBox(height: 60, child: Center(child: CircularProgressIndicator()));
        } else if (state is CategoriesLoaded) {
          final activeCategories = state.categories.where((c) => c.active).toList();

          return SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemCount: activeCategories.length + 1, // +1 لزر "الكل"
              itemBuilder: (context, index) {
                final isAllButton = index == 0;
                final categoryId = isAllButton ? null : activeCategories[index - 1].id;
                final categoryName = isAllButton ? 'الكل' : activeCategories[index - 1].name;
                
                final isSelected = _selectedCategoryId == categoryId;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(
                      categoryName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFF1E88E5),
                    backgroundColor: Colors.white,
                    onSelected: (_) => _onCategorySelected(categoryId),
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}