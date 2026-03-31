import '../../../../core/usecases/usecases.dart';
import '../entities/shift_entity.dart';
import '../repositories/shift_repository.dart';

class GetActiveShiftUseCase implements UseCase<ShiftEntity?, NoParams> {
  final ShiftRepository repository;

  GetActiveShiftUseCase(this.repository);

  @override
  Future<ShiftEntity?> call(NoParams params) async {
    return await repository.getActiveShift();
  }
}