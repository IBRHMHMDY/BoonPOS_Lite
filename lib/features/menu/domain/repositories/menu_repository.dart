import '../entities/category_entity.dart';
import '../entities/modifier_entity.dart';
import '../entities/product_entity.dart';

abstract class MenuRepository {
  // التصنيفات
  Future<List<CategoryEntity>> getCategories();
  Future<CategoryEntity> saveCategory(CategoryEntity category);
  Future<void> deleteCategory(int id); // Soft Delete

  // المنتجات
  Future<List<ProductEntity>> getProducts(int? categoryId);
  Future<ProductEntity> saveProduct(ProductEntity product);
  Future<void> deleteProduct(int id); // Soft Delete

  // الإضافات
  Future<List<ModifierEntity>> getModifiers(int productId);
  Future<ModifierEntity> saveModifier(ModifierEntity modifier);
  Future<void> deleteModifier(int id); // Soft Delete
}