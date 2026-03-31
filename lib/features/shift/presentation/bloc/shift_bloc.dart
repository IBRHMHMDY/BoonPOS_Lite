import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/shift_repository.dart';
import 'shift_event.dart';
import 'shift_state.dart';

class ShiftBloc extends Bloc<ShiftEvent, ShiftState> {
  final ShiftRepository repository;

  ShiftBloc({required this.repository}) : super(ShiftInitial()) {
    on<CheckActiveShiftEvent>(_onCheckActiveShift);
    on<OpenNewShiftEvent>(_onOpenNewShift);
  }

  Future<void> _onCheckActiveShift(CheckActiveShiftEvent event, Emitter<ShiftState> emit) async {
    emit(ShiftLoading());
    try {
      final shift = await repository.getActiveShift();
      if (shift != null) {
        emit(ShiftActive(shift: shift));
      } else {
        emit(ShiftNone());
      }
    } catch (e) {
      emit(const ShiftError(message: 'حدث خطأ أثناء التحقق من الوردية الحالية.'));
    }
  }

  Future<void> _onOpenNewShift(OpenNewShiftEvent event, Emitter<ShiftState> emit) async {
    emit(ShiftLoading());
    try {
      final newShift = await repository.openShift(event.userId, event.startingCash);
      emit(ShiftActive(shift: newShift));
    } catch (e) {
      emit(const ShiftError(message: 'حدث خطأ أثناء محاولة فتح وردية جديدة.'));
      emit(ShiftNone()); // للعودة لشاشة إدخال العهدة
    }
  }
}