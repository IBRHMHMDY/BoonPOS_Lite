import 'package:boon_pos_lite/features/auth/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../bloc/user/user_event.dart';
import '../bloc/user/user_state.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(GetUsersEvent());
  }

  void _showUserDialog(BuildContext context, {UserEntity? user}) {
    final bool isEditing = user != null;
    final nameController = TextEditingController(text: user?.name ?? '');
    final pinController = TextEditingController(text: user?.pinCode ?? '');
    String selectedRole = user?.role ?? 'cashier';
    bool isActive = user?.active ?? true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isEditing ? 'تعديل بيانات المستخدم' : 'إضافة مستخدم جديد'),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'اسم المستخدم (مثال: أحمد)'),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: pinController,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        maxLength: 4,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          labelText: 'الرمز السري (4 أرقام)',
                          counterText: '',
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: selectedRole,
                        decoration: const InputDecoration(labelText: 'الصلاحية (الدور)'),
                        items: const [
                          DropdownMenuItem(value: 'cashier', child: Text('كاشير (نقطة بيع فقط)')),
                          DropdownMenuItem(value: 'admin', child: Text('مدير (صلاحيات كاملة)')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => selectedRole = val);
                        },
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('حساب نشط'),
                        value: isActive,
                        onChanged: (value) => setState(() => isActive = value),
                        activeThumbColor: const Color(0xFF1E88E5),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final String name = nameController.text.trim();
                    final String pin = pinController.text.trim();

                    if (name.isEmpty || pin.length != 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('يرجى إدخال الاسم ورمز سري مكون من 4 أرقام'), backgroundColor: Colors.red),
                      );
                      return;
                    }

                    final newUser = UserEntity(
                      id: user?.id ?? 0,
                      name: name,
                      pinCode: pin,
                      role: selectedRole,
                      isActive: isActive ? 1 : 0,
                    );

                    context.read<UserBloc>().add(SaveUserEvent(user: newUser));
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('حفظ'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, UserEntity user) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف المستخدم "${user.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              context.read<UserBloc>().add(DeleteUserEvent(id: user.id));
              Navigator.pop(dialogContext);
            },
            child: const Text('تأكيد الحذف'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.green));
        } else if (state is UserError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
        }
      },
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UsersLoaded) {
          final users = state.users;

          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: users.isEmpty
                  ? const Center(child: Text('لا يوجد مستخدمين حالياً.', style: TextStyle(fontSize: 18)))
                  : ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final isAdmin = user.isAdmin;
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isAdmin ? Colors.blue.shade100 : Colors.green.shade100,
                              child: Icon(
                                isAdmin ? Icons.admin_panel_settings : Icons.person,
                                color: isAdmin ? Colors.blue.shade800 : Colors.green.shade800,
                              ),
                            ),
                            title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('الصلاحية: ${isAdmin ? "مدير نظام" : "كاشير"} | الحالة: ${user.active ? "نشط" : "موقوف"}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _showUserDialog(context, user: user),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _confirmDelete(context, user),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _showUserDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('إضافة مستخدم'),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}