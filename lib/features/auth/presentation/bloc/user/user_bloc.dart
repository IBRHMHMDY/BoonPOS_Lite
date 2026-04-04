import 'package:boon_pos_lite/features/auth/domain/usecases/delete_user.dart';
import 'package:boon_pos_lite/features/auth/domain/usecases/get_users.dart';
import 'package:boon_pos_lite/features/auth/domain/usecases/save_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUseCase getUsers;
  final SaveUserUseCase saveUser;
  final DeleteUserUseCase deleteUser;

  UserBloc({
    required this.getUsers,
    required this.saveUser,
    required this.deleteUser,
  }) : super(UserInitial()) {
    on<GetUsersEvent>(_onGetUsers);
    on<SaveUserEvent>(_onSaveUser);
    on<DeleteUserEvent>(_onDeleteUser);
  }

  Future<void> _onGetUsers(GetUsersEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final users = await getUsers(NoParams());
      emit(UsersLoaded(users: users));
    } catch (e) {
      emit(const UserError(message: 'حدث خطأ أثناء جلب قائمة المستخدمين.'));
    }
  }

  Future<void> _onSaveUser(SaveUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await saveUser(event.user);
      emit(const UserActionSuccess(message: 'تم حفظ بيانات المستخدم بنجاح.'));
      add(GetUsersEvent()); // تحديث القائمة
    } catch (e) {
      emit(const UserError(message: 'حدث خطأ أثناء حفظ المستخدم.'));
    }
  }

  Future<void> _onDeleteUser(DeleteUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await deleteUser(event.id);
      emit(const UserActionSuccess(message: 'تم حذف المستخدم بنجاح.'));
      add(GetUsersEvent()); // تحديث القائمة
    } catch (e) {
      emit(const UserError(message: 'حدث خطأ أثناء حذف المستخدم.'));
    }
  }
}