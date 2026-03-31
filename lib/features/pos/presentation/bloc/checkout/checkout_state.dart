import 'package:equatable/equatable.dart';
import '../../../domain/entities/order_entity.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();
  
  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutSuccess extends CheckoutState {
  final OrderEntity order;

  const CheckoutSuccess({required this.order});

  @override
  List<Object> get props => [order];
}

class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError({required this.message});

  @override
  List<Object> get props => [message];
}