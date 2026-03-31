import 'package:go_router/go_router.dart';
import '../../features/pos/presentation/screens/pos_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const PosScreen(),
    ),
    // سيتم إضافة مسارات شاشة الترخيص، تسجيل الدخول، والمصروفات لاحقاً
  ],
);