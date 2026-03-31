import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/widgets/custom_numpad.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _pin = '';
  final int _pinLength = 4; // الطول المعتمد للرمز السري

  void _onKeyPress(String key) {
    if (_pin.length < _pinLength) {
      setState(() {
        _pin += key;
      });
      // تفعيل التحقق التلقائي عند اكتمال الـ 4 أرقام
      if (_pin.length == _pinLength) {
        context.read<AuthBloc>().add(LoginWithPinEvent(pinCode: _pin));
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _onClear() {
    setState(() {
      _pin = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is Authenticated) {
                // إذا نجح الدخول، ننتقل لشاشة الورديات
                context.go('/shift');
              } else if (state is AuthError) {
                _onClear(); // تفريغ الحقل عند الخطأ
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                );
              }
            },
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // القسم الأيمن: واجهة إدخال الرمز
                  SizedBox(
                    width: 350,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock_person, size: 80, color: Color(0xFF1E88E5)),
                        const SizedBox(height: 20),
                        const Text(
                          'تسجيل الدخول',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text('يرجى إدخال الرمز السري الخاص بك (4 أرقام)'),
                        const SizedBox(height: 30),
                        // عرض الرموز المدخلة كنقاط
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_pinLength, (index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index < _pin.length ? const Color(0xFF1E88E5) : Colors.grey.shade300,
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 40),
                        if (state is AuthLoading)
                          const CircularProgressIndicator()
                        else
                          CustomNumpad(
                            onKeyPress: _onKeyPress,
                            onBackspace: _onBackspace,
                            onClear: _onClear,
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}