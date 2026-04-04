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
  final int _pinLength = 4;

  void _onKeyPress(String key) {
    if (_pin.length < _pinLength) {
      setState(() {
        _pin += key;
      });
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // لم نعد بحاجة لتحديد لون الـ Scaffold، الثيم سيتكفل به
    return Scaffold(
      body: Center(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              context.go('/shift');
            } else if (state is AuthError) {
              _onClear();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: colorScheme.error),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Container(
                width: 420, // عرض مناسب للتابلت
                padding: const EdgeInsets.all(40.0),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color ?? colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(),
                      blurRadius: 24,
                      spreadRadius: 8,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // أيقونة دائرية أنيقة
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.lock_person_rounded, size: 64, color: colorScheme.primary),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'تسجيل الدخول',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'يرجى إدخال الرمز السري الخاص بك (4 أرقام)',
                      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 40),
                    
                    // نقاط الرمز السري (مع أنيميشن ناعم)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_pinLength, (index) {
                        final isFilled = index < _pin.length;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isFilled ? colorScheme.primary : colorScheme.surface,
                            border: isFilled 
                                ? null 
                                : Border.all(color: colorScheme.primary.withValues(), width: 2),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 48),
                    
                    // حالة التحميل أو عرض لوحة الأرقام
                    if (state is AuthLoading)
                      const SizedBox(
                        height: 200, 
                        child: Center(child: CircularProgressIndicator())
                      )
                    else
                      CustomNumpad(
                        onKeyPress: _onKeyPress,
                        onBackspace: _onBackspace,
                        onClear: _onClear,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}