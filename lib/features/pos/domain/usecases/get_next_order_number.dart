import '../../../../core/usecases/usecase.dart';
import '../repositories/pos_repository.dart';

class GetNextOrderNumberUseCase implements UseCase<int, int> {
  final PosRepository repository;

  GetNextOrderNumberUseCase(this.repository);

  // المتغير الممرر (Params) هنا هو الـ shiftId
  @override
  Future<int> call(int shiftId) async {
    return await repository.getNextOrderNumber(shiftId);
  }
}