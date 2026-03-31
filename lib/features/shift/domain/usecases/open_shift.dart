import 'package:boon_pos_lite/core/usecases/usecase.dart';
import 'package:equatable/equatable.dart';
import '../entities/shift_entity.dart';
import '../repositories/shift_repository.dart';

class OpenShiftParams extends Equatable {
  final int userId;
  final double startingCash;

  const OpenShiftParams({required this.userId, required this.startingCash});

  @override
  List<Object> get props => [userId, startingCash];
}

class OpenShiftUseCase implements UseCase<ShiftEntity, OpenShiftParams> {
  final ShiftRepository repository;

  OpenShiftUseCase(this.repository);

  @override
  Future<ShiftEntity> call(OpenShiftParams params) async {
    return await repository.openShift(params.userId, params.startingCash);
  }
}