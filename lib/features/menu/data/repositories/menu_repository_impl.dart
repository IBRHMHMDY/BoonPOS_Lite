import '../../domain/entities/category_entity.dart';
import '../../domain/entities/modifier_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/menu_repository.dart';
import '../datasources/menu_local_data_source.dart';
import '../models/category_model.dart';
import '../models/modifier_model.dart';
import '../models/product_model.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuLocalDataSource localDataSource;

  MenuRepositoryImpl({required this.localDataSource});

  @override
  Future<List<CategoryEntity>> getCategories() async {
    return await localDataSource.getCategories();
  }

  @override
  Future<CategoryEntity> saveCategory(CategoryEntity category) async {
    final model = CategoryModel(
      id: category.id,
      name: category.name,
      colorHex: category.colorHex,
      sortOrder: category.sortOrder,
      isActive: category.isActive,
    );
    return await localDataSource.saveCategory(model);
  }

  @override
  Future<void> deleteCategory(int id) async {
    return await localDataSource.deleteCategory(id);
  }

  @override
  Future<List<ProductEntity>> getProducts(int? categoryId) async {
    return await localDataSource.getProducts(categoryId);
  }

  @override
  Future<ProductEntity> saveProduct(ProductEntity product) async {
    final model = ProductModel(
      id: product.id,
      categoryId: product.categoryId,
      barcode: product.barcode,
      name: product.name,
      costPrice: product.costPrice,
      sellingPrice: product.sellingPrice,
      isActive: product.isActive,
    );
    return await localDataSource.saveProduct(model);
  }

  @override
  Future<void> deleteProduct(int id) async {
    return await localDataSource.deleteProduct(id);
  }

  @override
  Future<List<ModifierEntity>> getModifiers(int productId) async {
    return await localDataSource.getModifiers(productId);
  }

  @override
  Future<ModifierEntity> saveModifier(ModifierEntity modifier) async {
    final model = ModifierModel(
      id: modifier.id,
      productId: modifier.productId,
      name: modifier.name,
      price: modifier.price,
      isActive: modifier.isActive,
    );
    return await localDataSource.saveModifier(model);
  }

  @override
  Future<void> deleteModifier(int id) async {
    return await localDataSource.deleteModifier(id);
  }
}