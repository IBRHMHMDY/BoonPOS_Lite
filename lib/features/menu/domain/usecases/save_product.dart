import '../../../../core/usecases/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/menu_repository.dart';

class SaveProductUseCase implements UseCase<ProductEntity, ProductEntity> {
  final MenuRepository repository;

  SaveProductUseCase(this.repository);

  @override
  Future<ProductEntity> call(ProductEntity product) async {
    return await repository.saveProduct(product);
  }
}