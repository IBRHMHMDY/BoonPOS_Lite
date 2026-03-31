import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/delete_category.dart';
import '../../../domain/usecases/get_categories.dart';
import '../../../domain/usecases/save_category.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoriesUseCase getCategories;
  final SaveCategoryUseCase saveCategory;
  final DeleteCategoryUseCase deleteCategory;

  CategoryBloc({
    required this.getCategories,
    required this.saveCategory,
    required this.deleteCategory,
  }) : super(CategoryInitial()) {
    on<GetCategoriesEvent>(_onGetCategories);
    on<SaveCategoryEvent>(_onSaveCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
  }

  Future<void> _onGetCategories(GetCategoriesEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final categories = await getCategories(NoParams());
      emit(CategoriesLoaded(categories: categories));
    } catch (e) {
      emit(const CategoryError(message: 'حدث خطأ أثناء جلب التصنيفات.'));
    }
  }

  Future<void> _onSaveCategory(SaveCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      await saveCategory(event.category);
      emit(const CategoryActionSuccess(message: 'تم حفظ التصنيف بنجاح.'));
      // إعادة جلب القائمة المحدثة
      add(GetCategoriesEvent());
    } catch (e) {
      emit(const CategoryError(message: 'حدث خطأ أثناء حفظ التصنيف.'));
    }
  }

  Future<void> _onDeleteCategory(DeleteCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      await deleteCategory(event.id);
      emit(const CategoryActionSuccess(message: 'تم حذف التصنيف بنجاح.'));
      // إعادة جلب القائمة المحدثة
      add(GetCategoriesEvent());
    } catch (e) {
      emit(const CategoryError(message: 'حدث خطأ أثناء حذف التصنيف.'));
    }
  }
}