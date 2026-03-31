import 'package:equatable/equatable.dart';

abstract class ShiftEvent extends Equatable {
  const ShiftEvent();

  @override
  List<Object> get props => [];
}

class CheckActiveShiftEvent extends ShiftEvent {}

class OpenNewShiftEvent extends ShiftEvent {
  final int userId;
  final double startingCash;

  const OpenNewShiftEvent({
    required this.userId,
    required this.startingCash,
  });

  @override
  List<Object> get props => [userId, startingCash];
}