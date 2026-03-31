import 'package:equatable/equatable.dart';
import '../../../domain/entities/modifier_entity.dart';

abstract class ModifierState extends Equatable {
  const ModifierState();

  @override
  List<Object?> get props => [];
}

class ModifierInitial extends ModifierState {}

class ModifierLoading extends ModifierState {}

class ModifiersLoaded extends ModifierState {
  final List<ModifierEntity> modifiers;

  const ModifiersLoaded({required this.modifiers});

  @override
  List<Object> get props => [modifiers];
}

class ModifierActionSuccess extends ModifierState {
  final String message;

  const ModifierActionSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class ModifierError extends ModifierState {
  final String message;

  const ModifierError({required this.message});

  @override
  List<Object> get props => [message];
}