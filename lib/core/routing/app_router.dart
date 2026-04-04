import 'package:boon_pos_lite/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/pos/presentation/screens/pos_screen.dart';
import '../../features/license/presentation/screens/license_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/shift/presentation/screens/open_shift_screen.dart';
import '../../features/menu/presentation/screens/menu_dashboard_screen.dart'; // <--- استيراد المنيو
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/shift/presentation/bloc/shift_bloc.dart';
import '../di/service_locator.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/license', 
  routes: [
    GoRoute(
      path: '/license',
      name: 'license',
      builder: (context, state) => const LicenseScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => BlocProvider(
        create: (context) => sl<AuthBloc>(),
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      path: '/shift',
      name: 'shift',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<AuthBloc>()..add(CheckAuthSessionEvent())),
          BlocProvider(create: (context) => sl<ShiftBloc>()),
        ],
        child: const OpenShiftScreen(),
      ),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const PosScreen(),
    ),
    // إضافة مسار إدارة المنيو
    GoRoute(
      path: '/menu',
      name: 'menu',
      builder: (context, state) => const MenuDashboardScreen(),
    ),
  ],
);