import '../../domain/entities/shift_entity.dart';

class ShiftModel extends ShiftEntity {
  const ShiftModel({
    required super.id,
    required super.userId,
    required super.openedAt,
    super.closedAt,
    required super.startingCash,
    super.actualCash,
    required super.status,
  });

  factory ShiftModel.fromMap(Map<String, dynamic> map) {
    return ShiftModel(
      id: map['id'],
      userId: map['user_id'],
      openedAt: map['opened_at'],
      closedAt: map['closed_at'],
      startingCash: map['starting_cash'],
      actualCash: map['actual_cash'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'opened_at': openedAt,
      'closed_at': closedAt,
      'starting_cash': startingCash,
      'actual_cash': actualCash,
      'status': status,
    };
  }
}