import '../../../../core/usecases/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/menu_repository.dart';

// نمرر null لجلب كل المنتجات، أو categoryId لجلب منتجات قسم معين
class GetProductsUseCase implements UseCase<List<ProductEntity>, int?> {
  final MenuRepository repository;

  GetProductsUseCase(this.repository);

  @override
  Future<List<ProductEntity>> call(int? categoryId) async {
    return await repository.getProducts(categoryId);
  }
}