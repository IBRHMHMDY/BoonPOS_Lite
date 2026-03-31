import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_active_shift.dart';
import '../../domain/usecases/open_shift.dart';
import 'shift_event.dart';
import 'shift_state.dart';

class ShiftBloc extends Bloc<ShiftEvent, ShiftState> {
  final GetActiveShiftUseCase getActiveShift;
  final OpenShiftUseCase openShift;

  ShiftBloc({
    required this.getActiveShift,
    required this.openShift,
  }) : super(ShiftInitial()) {
    on<CheckActiveShiftEvent>(_onCheckActiveShift);
    on<OpenNewShiftEvent>(_onOpenNewShift);
  }

  Future<void> _onCheckActiveShift(CheckActiveShiftEvent event, Emitter<ShiftState> emit) async {
    emit(ShiftLoading());
    try {
      final shift = await getActiveShift(NoParams());
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
      final newShift = await openShift(OpenShiftParams(
        userId: event.userId,
        startingCash: event.startingCash,
      ));
      emit(ShiftActive(shift: newShift));
    } catch (e) {
      emit(const ShiftError(message: 'حدث خطأ أثناء محاولة فتح وردية جديدة.'));
      emit(ShiftNone());
    }
  }
}