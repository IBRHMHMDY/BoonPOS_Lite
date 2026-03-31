import 'package:equatable/equatable.dart';
import '../../../domain/entities/modifier_entity.dart';

abstract class ModifierEvent extends Equatable {
  const ModifierEvent();

  @override
  List<Object> get props => [];
}

class GetModifiersEvent extends ModifierEvent {
  final int productId;

  const GetModifiersEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}

class SaveModifierEvent extends ModifierEvent {
  final ModifierEntity modifier;
  final int productId; // لتحديث القائمة بعد الحفظ

  const SaveModifierEvent({required this.modifier, required this.productId});

  @override
  List<Object> get props => [modifier, productId];
}

class DeleteModifierEvent extends ModifierEvent {
  final int id;
  final int productId;

  const DeleteModifierEvent({required this.id, required this.productId});

  @override
  List<Object> get props => [id, productId];
}