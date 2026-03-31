import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/delete_product.dart';
import '../../../domain/usecases/get_products.dart';
import '../../../domain/usecases/save_product.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProducts;
  final SaveProductUseCase saveProduct;
  final DeleteProductUseCase deleteProduct;

  ProductBloc({
    required this.getProducts,
    required this.saveProduct,
    required this.deleteProduct,
  }) : super(ProductInitial()) {
    on<GetProductsEvent>(_onGetProducts);
    on<SaveProductEvent>(_onSaveProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onGetProducts(GetProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await getProducts(event.categoryId);
      emit(ProductsLoaded(products: products));
    } catch (e) {
      emit(const ProductError(message: 'حدث خطأ أثناء جلب المنتجات.'));
    }
  }

  Future<void> _onSaveProduct(SaveProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      await saveProduct(event.product);
      emit(const ProductActionSuccess(message: 'تم حفظ المنتج بنجاح.'));
      add(GetProductsEvent(categoryId: event.currentCategoryId));
    } catch (e) {
      emit(const ProductError(message: 'حدث خطأ أثناء حفظ المنتج.'));
    }
  }

  Future<void> _onDeleteProduct(DeleteProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      await deleteProduct(event.id);
      emit(const ProductActionSuccess(message: 'تم حذف المنتج بنجاح.'));
      add(GetProductsEvent(categoryId: event.currentCategoryId));
    } catch (e) {
      emit(const ProductError(message: 'حدث خطأ أثناء حذف المنتج.'));
    }
  }
}