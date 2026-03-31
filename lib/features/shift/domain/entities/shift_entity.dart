import 'package:equatable/equatable.dart';

class ShiftEntity extends Equatable {
  final int id;
  final int userId;
  final String openedAt;
  final String? closedAt;
  final double startingCash;
  final double? actualCash;
  final String status;

  const ShiftEntity({
    required this.id,
    required this.userId,
    required this.openedAt,
    this.closedAt,
    required this.startingCash,
    this.actualCash,
    required this.status,
  });

  bool get isOpen => status == 'open';

  @override
  List<Object?> get props => [
        id,
        userId,
        openedAt,
        closedAt,
        startingCash,
        actualCash,
        status,
      ];
}