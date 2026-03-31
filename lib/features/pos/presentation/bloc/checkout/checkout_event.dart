import 'package:equatable/equatable.dart';
import '../cart/cart_state.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

class ProcessCheckoutEvent extends CheckoutEvent {
  final int shiftId;
  final CartState cartState;
  final double paidCash;
  final double paidVisa;
  final double paidWallet;

  const ProcessCheckoutEvent({
    required this.shiftId,
    required this.cartState,
    this.paidCash = 0.0,
    this.paidVisa = 0.0,
    this.paidWallet = 0.0,
  });

  @override
  List<Object> get props => [shiftId, cartState, paidCash, paidVisa, paidWallet];
}