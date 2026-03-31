import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/delete_modifier.dart';
import '../../../domain/usecases/get_modifiers.dart';
import '../../../domain/usecases/save_modifier.dart';
import 'modifier_event.dart';
import 'modifier_state.dart';

class ModifierBloc extends Bloc<ModifierEvent, ModifierState> {
  final GetModifiersUseCase getModifiers;
  final SaveModifierUseCase saveModifier;
  final DeleteModifierUseCase deleteModifier;

  ModifierBloc({
    required this.getModifiers,
    required this.saveModifier,
    required this.deleteModifier,
  }) : super(ModifierInitial()) {
    on<GetModifiersEvent>(_onGetModifiers);
    on<SaveModifierEvent>(_onSaveModifier);
    on<DeleteModifierEvent>(_onDeleteModifier);
  }

  Future<void> _onGetModifiers(GetModifiersEvent event, Emitter<ModifierState> emit) async {
    emit(ModifierLoading());
    try {
      final modifiers = await getModifiers(event.productId);
      emit(ModifiersLoaded(modifiers: modifiers));
    } catch (e) {
      emit(const ModifierError(message: 'حدث خطأ أثناء جلب الإضافات.'));
    }
  }

  Future<void> _onSaveModifier(SaveModifierEvent event, Emitter<ModifierState> emit) async {
    emit(ModifierLoading());
    try {
      await saveModifier(event.modifier);
      emit(const ModifierActionSuccess(message: 'تم حفظ الإضافة بنجاح.'));
      add(GetModifiersEvent(productId: event.productId));
    } catch (e) {
      emit(const ModifierError(message: 'حدث خطأ أثناء حفظ الإضافة.'));
    }
  }

  Future<void> _onDeleteModifier(DeleteModifierEvent event, Emitter<ModifierState> emit) async {
    emit(ModifierLoading());
    try {
      await deleteModifier(event.id);
      emit(const ModifierActionSuccess(message: 'تم حذف الإضافة بنجاح.'));
      add(GetModifiersEvent(productId: event.productId));
    } catch (e) {
      emit(const ModifierError(message: 'حدث خطأ أثناء حذف الإضافة.'));
    }
  }
}