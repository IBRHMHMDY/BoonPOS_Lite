import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login_with_pin.dart';
import '../../domain/usecases/logout.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCurrentUserUseCase getCurrentUser;
  final LoginWithPinUseCase loginWithPin;
  final LogoutUseCase logout;

  AuthBloc({
    required this.getCurrentUser,
    required this.loginWithPin,
    required this.logout,
  }) : super(AuthInitial()) {
    on<CheckAuthSessionEvent>(_onCheckAuthSession);
    on<LoginWithPinEvent>(_onLoginWithPin);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onCheckAuthSession(CheckAuthSessionEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await getCurrentUser(NoParams());
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
      final user = await loginWithPin(event.pinCode);
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(const AuthError(message: 'الرمز السري غير صحيح أو الحساب موقوف.'));
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(const AuthError(message: 'حدث خطأ غير متوقع أثناء تسجيل الدخول.'));
      emit(Unauthenticated());
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await logout(NoParams());
      emit(Unauthenticated());
    } catch (e) {
      emit(const AuthError(message: 'حدث خطأ أثناء تسجيل الخروج.'));
    }
  }
}