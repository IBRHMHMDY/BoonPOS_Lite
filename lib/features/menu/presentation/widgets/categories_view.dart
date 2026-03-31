import 'package:boon_pos_lite/features/menu/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  @override
  void initState() {
    super.initState();
    // جلب التصنيفات بمجرد فتح التبويب
    context.read<CategoryBloc>().add(GetCategoriesEvent());
  }

  void _showCategoryDialog(BuildContext context, {CategoryEntity? category}) {
    final bool isEditing = category != null;
    final nameController = TextEditingController(text: category?.name ?? '');
    final sortOrderController = TextEditingController(text: category?.sortOrder.toString() ?? '0');
    bool isActive = category?.active ?? true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isEditing ? 'تعديل التصنيف' : 'إضافة تصنيف جديد'),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'اسم التصنيف',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: sortOrderController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'ترتيب الظهور (رقم)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('تفعيل التصنيف (يظهر في نقطة البيع)'),
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
                    final int sortOrder = int.tryParse(sortOrderController.text) ?? 0;

                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('يرجى إدخال اسم التصنيف'), backgroundColor: Colors.red),
                      );
                      return;
                    }

                    final newCategory = CategoryEntity(
                      id: category?.id ?? 0,
                      name: name,
                      colorHex: category?.colorHex,
                      sortOrder: sortOrder,
                      isActive: isActive ? 1 : 0,
                    );

                    context.read<CategoryBloc>().add(SaveCategoryEvent(category: newCategory));
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

  void _confirmDelete(BuildContext context, CategoryEntity category) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف التصنيف "${category.name}"؟\n(سيتم إخفاؤه فقط للحفاظ على السجلات القديمة)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              context.read<CategoryBloc>().add(DeleteCategoryEvent(id: category.id));
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
    return BlocConsumer<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state is CategoryActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.green),
          );
        } else if (state is CategoryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoriesLoaded) {
          final categories = state.categories;

          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: categories.isEmpty
                  ? const Center(child: Text('لا توجد تصنيفات حالياً. أضف تصنيفاً جديداً.'))
                  : ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: Text(category.sortOrder.toString()),
                            ),
                            title: Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(category.active ? 'نشط' : 'غير نشط'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _showCategoryDialog(context, category: category),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _confirmDelete(context, category),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _showCategoryDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('إضافة تصنيف'),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}