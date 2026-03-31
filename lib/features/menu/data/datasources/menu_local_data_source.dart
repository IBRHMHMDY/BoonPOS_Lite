import '../models/category_model.dart';
import '../models/modifier_model.dart';
import '../models/product_model.dart';

abstract class MenuLocalDataSource {
  // التصنيفات
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel> saveCategory(CategoryModel category);
  Future<void> deleteCategory(int id);

  // المنتجات
  Future<List<ProductModel>> getProducts(int? categoryId);
  Future<ProductModel> saveProduct(ProductModel product);
  Future<void> deleteProduct(int id);

  // الإضافات
  Future<List<ModifierModel>> getModifiers(int productId);
  Future<ModifierModel> saveModifier(ModifierModel modifier);
  Future<void> deleteModifier(int id);
}