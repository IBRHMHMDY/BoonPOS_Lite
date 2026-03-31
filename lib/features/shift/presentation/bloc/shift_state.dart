import 'package:equatable/equatable.dart';
import '../../domain/entities/shift_entity.dart';

abstract class ShiftState extends Equatable {
  const ShiftState();
  
  @override
  List<Object?> get props => [];
}

class ShiftInitial extends ShiftState {}

class ShiftLoading extends ShiftState {}

class ShiftActive extends ShiftState {
  final ShiftEntity shift;

  const ShiftActive({required this.shift});

  @override
  List<Object> get props => [shift];
}

class ShiftNone extends ShiftState {
  // هذه الحالة تعني عدم وجود وردية مفتوحة، ويجب إظهار شاشة "فتح الوردية"
}

class ShiftError extends ShiftState {
  final String message;

  const ShiftError({required this.message});

  @override
  List<Object> get props => [message];
}