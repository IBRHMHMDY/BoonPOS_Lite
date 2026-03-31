import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<CheckAuthSessionEvent>(_onCheckAuthSession);
    on<LoginWithPinEvent>(_onLoginWithPin);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onCheckAuthSession(CheckAuthSessionEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await repository.getCurrentUser();
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(const AuthError(message: 'حدث خطأ أثناء التحقق من الجلسة.'));
    }
  }

  Future<void> _onLoginWithPin(LoginWithPinEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await repository.loginWithPin(event.pinCode);
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(const AuthError(message: 'الرمز السري غير صحيح أو الحساب موقوف.'));
        emit(Unauthenticated()); // للعودة لحالة إدخال الرمز
      }
    } catch (e) {
      emit(const AuthError(message: 'حدث خطأ غير متوقع أثناء تسجيل الدخول.'));
      emit(Unauthenticated());
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await repository.logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(const AuthError(message: 'حدث خطأ أثناء تسجيل الخروج.'));
    }
  }
}