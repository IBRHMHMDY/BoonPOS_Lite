import 'package:boon_pos_lite/features/menu/domain/entities/modifier_entity.dart';
import 'package:boon_pos_lite/features/menu/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/modifier/modifier_bloc.dart';
import '../bloc/modifier/modifier_event.dart';
import '../bloc/modifier/modifier_state.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/product/product_event.dart';
import '../bloc/product/product_state.dart';

class ModifiersView extends StatefulWidget {
  const ModifiersView({super.key});

  @override
  State<ModifiersView> createState() => _ModifiersViewState();
}

class _ModifiersViewState extends State<ModifiersView> {
  int? _selectedProductId;

  @override
  void initState() {
    super.initState();
    // جلب المنتجات النشطة لملء القائمة المنسدلة للفلترة
    context.read<ProductBloc>().add(const GetProductsEvent(categoryId: null));
  }

  void _showModifierDialog(BuildContext context, {ModifierEntity? modifier, required int productId}) {
    final bool isEditing = modifier != null;
    final nameController = TextEditingController(text: modifier?.name ?? '');
    final priceController = TextEditingController(text: modifier?.price.toString() ?? '');
    bool isActive = modifier?.active ?? true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (stateContext, setState) {
            return AlertDialog(
              title: Text(isEditing ? 'تعديل الإضافة' : 'إضافة جديدة للمنتج'),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'اسم الإضافة (مثال: صوص زيادة)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: priceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'سعر الإضافة (يمكن أن يكون 0)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('تفعيل الإضافة (تظهر في نقطة البيع)'),
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
                    final double price = double.tryParse(priceController.text) ?? 0.0;

                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('يرجى إدخال اسم الإضافة.'), backgroundColor: Colors.red),
                      );
                      return;
                    }

                    final newModifier = ModifierEntity(
                      id: modifier?.id ?? 0,
                      productId: productId,
                      name: name,
                      price: price,
                      isActive: isActive ? 1 : 0,
                    );

                    context.read<ModifierBloc>().add(SaveModifierEvent(
                      modifier: newModifier,
                      productId: productId,
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

  void _confirmDelete(BuildContext context, ModifierEntity modifier) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف الإضافة "${modifier.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              context.read<ModifierBloc>().add(DeleteModifierEvent(
                id: modifier.id,
                productId: modifier.productId,
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
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, productState) {
        List<ProductEntity> activeProducts = [];
        if (productState is ProductsLoaded) {
          activeProducts = productState.products.where((p) => p.active).toList();
          
          // التأكد من أن المنتج المحدد لا يزال موجوداً ونشطاً
          if (_selectedProductId != null && !activeProducts.any((p) => p.id == _selectedProductId)) {
            _selectedProductId = null;
          }
        }

        return Scaffold(
          body: Column(
            children: [
              // قسم اختيار المنتج (أساسي لجلب الإضافات)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Text('اختر المنتج لعرض إضافاته: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          hintText: 'يرجى اختيار منتج أولاً',
                        ),
                        initialValue: _selectedProductId,
                        items: activeProducts.map((p) => DropdownMenuItem<int?>(
                              value: p.id,
                              child: Text(p.name),
                            )).toList(),
                        onChanged: (value) {
                          setState(() => _selectedProductId = value);
                          if (value != null) {
                            context.read<ModifierBloc>().add(GetModifiersEvent(productId: value));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // فاصل بصري
              const Divider(height: 1, thickness: 1),

              // قسم عرض الإضافات
              Expanded(
                child: _selectedProductId == null
                    ? const Center(
                        child: Text(
                          'يرجى اختيار منتج من القائمة بالأعلى لعرض وإدارة الإضافات الخاصة به.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : BlocConsumer<ModifierBloc, ModifierState>(
                        listener: (context, state) {
                          if (state is ModifierActionSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
                            );
                          } else if (state is ModifierError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is ModifierLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is ModifiersLoaded) {
                            final modifiers = state.modifiers;

                            if (modifiers.isEmpty) {
                              return const Center(child: Text('لا توجد إضافات لهذا المنتج.'));
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.all(16.0),
                              itemCount: modifiers.length,
                              itemBuilder: (context, index) {
                                final modifier = modifiers[index];
                                return Card(
                                  elevation: 2,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.green.shade100,
                                      child: const Icon(Icons.extension, color: Colors.green),
                                    ),
                                    title: Text(modifier.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Text('السعر: ${modifier.price} ج.م ${modifier.active ? '(نشط)' : '(مخفي)'}'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.blue),
                                          onPressed: () => _showModifierDialog(
                                            context, 
                                            modifier: modifier, 
                                            productId: _selectedProductId!,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => _confirmDelete(context, modifier),
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
              if (_selectedProductId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('يجب اختيار المنتج أولاً قبل إضافة عنصر إليه.'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }
              _showModifierDialog(context, productId: _selectedProductId!);
            },
            icon: const Icon(Icons.add),
            label: const Text('إضافة جديدة'),
            backgroundColor: _selectedProductId == null ? Colors.grey : const Color(0xFF1E88E5),
          ),
        );
      },
    );
  }
}