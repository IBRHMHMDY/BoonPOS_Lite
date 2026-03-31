import 'package:boon_pos_lite/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/shift_bloc.dart';
import '../bloc/shift_event.dart';
import '../bloc/shift_state.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../../core/widgets/custom_numpad.dart';

class OpenShiftScreen extends StatefulWidget {
  const OpenShiftScreen({super.key});

  @override
  State<OpenShiftScreen> createState() => _OpenShiftScreenState();
}

class _OpenShiftScreenState extends State<OpenShiftScreen> {
  String _amount = '0';

  @override
  void initState() {
    super.initState();
    // التحقق فور دخول الشاشة ما إذا كانت هناك وردية مفتوحة
    context.read<ShiftBloc>().add(CheckActiveShiftEvent());
  }

  void _onKeyPress(String key) {
    setState(() {
      if (_amount == '0' && key != '.') {
        _amount = key;
      } else {
        // منع إدخال أكثر من نقطة عشرية واحدة
        if (key == '.' && _amount.contains('.')) return;
        _amount += key;
      }
    });
  }

  void _onBackspace() {
    if (_amount.length > 1) {
      setState(() => _amount = _amount.substring(0, _amount.length - 1));
    } else {
      setState(() => _amount = '0');
    }
  }

  void _onClear() {
    setState(() => _amount = '0');
  }

  void _openNewShift(BuildContext context) {
    final double startingCash = double.tryParse(_amount) ?? 0.0;
    // جلب الـ ID الخاص بالمستخدم الحالي من الـ AuthBloc
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<ShiftBloc>().add(
        OpenNewShiftEvent(
          userId: authState.user.id,
          startingCash: startingCash,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: const Text('إدارة الورديات'),
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            context.read<AuthBloc>().add(LogoutEvent());
            context.go('/login');
          },
        ),
      ),
      body: Center(
        child: BlocConsumer<ShiftBloc, ShiftState>(
          listener: (context, state) {
            if (state is ShiftActive) {
              // إذا وجدت وردية مفتوحة أو تم فتح واحدة للتو، ننتقل لـ POS
              context.go('/home');
            } else if (state is ShiftError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ShiftLoading || state is ShiftInitial) {
              return const CircularProgressIndicator();
            } else if (state is ShiftNone || state is ShiftError) {
              return _buildOpenShiftForm(context);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildOpenShiftForm(BuildContext context) {
    return Center(
      // وضعناها في المركز لتبقى في المنتصف حتى مع الـ Scroll
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
        ), // مسافة أمان علوية وسفلية
        child: SizedBox(
          width: 380, // زيادة العرض قليلاً لتعويض تصغير الـ Numpad
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.point_of_sale,
                size: 56,
                color: Color(0xFF1E88E5),
              ), // تصغير الأيقونة
              const SizedBox(height: 12),
              const Text(
                'فتح وردية جديدة',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('يرجى إدخال مبلغ العهدة الافتتاحية (الفكة بالدرج)'),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ), // تصغير البادينج الداخلي
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF1E88E5), width: 2),
                ),
                child: Text(
                  '$_amount ج.م',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E88E5),
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ),
              const SizedBox(height: 16),
              CustomNumpad(
                onKeyPress: _onKeyPress,
                onBackspace: _onBackspace,
                onClear: _onClear,
                showClearButton: true,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 55, // تصغير ارتفاع الزر قليلاً
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _openNewShift(context),
                  child: const Text(
                    'بدء الوردية والذهاب للبيع',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
