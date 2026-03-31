import 'package:boon_pos_lite/features/menu/domain/entities/category_entity.dart';
import 'package:boon_pos_lite/features/menu/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_state.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/product/product_event.dart';
import '../bloc/product/product_state.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  int? _selectedFilterCategoryId; // للفلترة (عرض منتجات قسم معين)

  @override
  void initState() {
    super.initState();
    // جلب المنتجات (كل المنتجات مبدئياً)
    context.read<ProductBloc>().add(const GetProductsEvent(categoryId: null));
    // لا نحتاج لطلب جلب التصنيفات هنا لأنها جُلبت بالفعل في CategoriesView 
    // ولكن من الجيد الاعتماد على حالتها الموجودة في الـ Bloc
  }

  void _showProductDialog(BuildContext context, {ProductEntity? product, required List<CategoryEntity> availableCategories}) {
    final bool isEditing = product != null;
    final nameController = TextEditingController(text: product?.name ?? '');
    final barcodeController = TextEditingController(text: product?.barcode ?? '');
    final costPriceController = TextEditingController(text: product?.costPrice.toString() ?? '');
    final sellingPriceController = TextEditingController(text: product?.sellingPrice.toString() ?? '');
    
    int? selectedCategoryId = product?.categoryId;
    // التأكد من أن التصنيف المختار لا يزال موجوداً في القائمة
    if (selectedCategoryId != null && !availableCategories.any((c) => c.id == selectedCategoryId)) {
      selectedCategoryId = null;
    }
    
    bool isActive = product?.active ?? true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isEditing ? 'تعديل المنتج' : 'إضافة منتج جديد'),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 500,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // قائمة منسدلة لاختيار التصنيف
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'اختر التصنيف',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: selectedCategoryId,
                        items: availableCategories.map((category) {
                          return DropdownMenuItem<int>(
                            value: category.id,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => selectedCategoryId = value),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'اسم المنتج',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: barcodeController,
                        decoration: const InputDecoration(
                          labelText: 'الباركود (اختياري للبيع السريع)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: costPriceController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'سعر التكلفة',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: sellingPriceController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'سعر البيع',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('تفعيل المنتج (يظهر في نقطة البيع)'),
                        value: isActive,
                        onChanged: (value) => setState(() => isActive = value),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final String name = nameController.text.trim();
                    final String barcode = barcodeController.text.trim();
                    final double costPrice = double.tryParse(costPriceController.text) ?? 0.0;
                    final double sellingPrice = double.tryParse(sellingPriceController.text) ?? 0.0;

                    if (name.isEmpty || selectedCategoryId == null || sellingPrice <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('الاسم، التصنيف، وسعر البيع (أكبر من صفر) حقول مطلوبة.'), 
                          backgroundColor: Colors.red
                        ),
                      );
                      return;
                    }

                    final newProduct = ProductEntity(
                      id: product?.id ?? 0,
                      categoryId: selectedCategoryId!,
                      barcode: barcode.isEmpty ? null : barcode,
                      name: name,
                      costPrice: costPrice,
                      sellingPrice: sellingPrice,
                      isActive: isActive ? 1 : 0,
                    );

                    context.read<ProductBloc>().add(SaveProductEvent(
                      product: newProduct, 
                      currentCategoryId: _selectedFilterCategoryId,
                    ));
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('حفظ'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, ProductEntity product) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف المنتج "${product.name}"؟\n(سيتم إخفاؤه فقط للحفاظ على فواتير المبيعات القديمة)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              context.read<ProductBloc>().add(DeleteProductEvent(
                id: product.id,
                currentCategoryId: _selectedFilterCategoryId,
              ));
              Navigator.pop(dialogContext);
            },
            child: const Text('تأكيد الحذف'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // نحتاج لقراءة حالة التصنيفات أولاً لربطها بالمنتجات (سواء للفلترة أو للإضافة)
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, categoryState) {
        List<CategoryEntity> activeCategories = [];
        if (categoryState is CategoriesLoaded) {
          activeCategories = categoryState.categories.where((c) => c.active).toList();
        }

        return BlocConsumer<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.green),
              );
            } else if (state is ProductError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              body: Column(
                children: [
                  // شريط فلترة التصنيفات العُلوي
                  if (activeCategories.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Text('فلترة حسب التصنيف: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<int?>(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                              ),
                              initialValue: _selectedFilterCategoryId,
                              items: [
                                const DropdownMenuItem<int?>(
                                  value: null,
                                  child: Text('الكل'),
                                ),
                                ...activeCategories.map((c) => DropdownMenuItem<int?>(
                                      value: c.id,
                                      child: Text(c.name),
                                    )),
                              ],
                              onChanged: (value) {
                                setState(() => _selectedFilterCategoryId = value);
                                context.read<ProductBloc>().add(GetProductsEvent(categoryId: value));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                  // عرض المنتجات
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (state is ProductLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is ProductsLoaded) {
                          final products = state.products;

                          if (products.isEmpty) {
                            return const Center(child: Text('لا توجد منتجات. قم بإضافة منتج جديد.'));
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              // البحث عن اسم التصنيف لعرضه
                              final catName = activeCategories.firstWhere(
                                (c) => c.id == product.categoryId, 
                                orElse: () => const CategoryEntity(id: 0, name: 'غير معروف', sortOrder: 0, isActive: 0),
                              ).name;

                              return Card(
                                elevation: 2,
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.orange.shade100,
                                    child: const Icon(Icons.fastfood, color: Colors.orange),
                                  ),
                                  title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text('القسم: $catName | السعر: ${product.sellingPrice} ج.م ${product.active ? '(نشط)' : '(مخفي)'}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () => _showProductDialog(
                                          context, 
                                          product: product, 
                                          availableCategories: activeCategories,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _confirmDelete(context, product),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  if (activeCategories.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('يجب إضافة وتفعيل تصنيف واحد على الأقل قبل إضافة المنتجات.'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }
                  _showProductDialog(context, availableCategories: activeCategories);
                },
                icon: const Icon(Icons.add),
                label: const Text('إضافة منتج'),
              ),
            );
          },
        );
      },
    );
  }
}