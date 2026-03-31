import '../../../../core/database/database_service.dart';
import '../models/category_model.dart';
import '../models/modifier_model.dart';
import '../models/product_model.dart';
import 'menu_local_data_source.dart';

class MenuLocalDataSourceImpl implements MenuLocalDataSource {
  final DatabaseService databaseService;

  MenuLocalDataSourceImpl({required this.databaseService});

  @override
  Future<List<CategoryModel>> getCategories() async {
    final db = await databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: 'is_active = 1',
      orderBy: 'sort_order ASC',
    );
    return maps.map((e) => CategoryModel.fromMap(e)).toList();
  }

  @override
  Future<CategoryModel> saveCategory(CategoryModel category) async {
    final db = await databaseService.database;
    if (category.id == 0) {
      final id = await db.insert('categories', category.toMap());
      return CategoryModel(
        id: id,
        name: category.name,
        colorHex: category.colorHex,
        sortOrder: category.sortOrder,
        isActive: category.isActive,
      );
    } else {
      await db.update('categories', category.toMap(), where: 'id = ?', whereArgs: [category.id]);
      return category;
    }
  }

  @override
  Future<void> deleteCategory(int id) async {
    final db = await databaseService.database;
    await db.update('categories', {'is_active': 0}, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<ProductModel>> getProducts(int? categoryId) async {
    final db = await databaseService.database;
    List<Map<String, dynamic>> maps;

    if (categoryId != null) {
      maps = await db.query(
        'products',
        where: 'category_id = ? AND is_active = 1',
        whereArgs: [categoryId],
      );
    } else {
      maps = await db.query('products', where: 'is_active = 1');
    }
    return maps.map((e) => ProductModel.fromMap(e)).toList();
  }

  @override
  Future<ProductModel> saveProduct(ProductModel product) async {
    final db = await databaseService.database;
    if (product.id == 0) {
      final id = await db.insert('products', product.toMap());
      return ProductModel(
        id: id,
        categoryId: product.categoryId,
        barcode: product.barcode,
        name: product.name,
        costPrice: product.costPrice,
        sellingPrice: product.sellingPrice,
        isActive: product.isActive,
      );
    } else {
      await db.update('products', product.toMap(), where: 'id = ?', whereArgs: [product.id]);
      return product;
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    final db = await databaseService.database;
    await db.update('products', {'is_active': 0}, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<ModifierModel>> getModifiers(int productId) async {
    final db = await databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'modifiers',
      where: 'product_id = ? AND is_active = 1',
      whereArgs: [productId],
    );
    return maps.map((e) => ModifierModel.fromMap(e)).toList();
  }

  @override
  Future<ModifierModel> saveModifier(ModifierModel modifier) async {
    final db = await databaseService.database;
    if (modifier.id == 0) {
      final id = await db.insert('modifiers', modifier.toMap());
      return ModifierModel(
        id: id,
        productId: modifier.productId,
        name: modifier.name,
        price: modifier.price,
        isActive: modifier.isActive,
      );
    } else {
      await db.update('modifiers', modifier.toMap(), where: 'id = ?', whereArgs: [modifier.id]);
      return modifier;
    }
  }

  @override
  Future<void> deleteModifier(int id) async {
    final db = await databaseService.database;
    await db.update('modifiers', {'is_active': 0}, where: 'id = ?', whereArgs: [id]);
  }
}