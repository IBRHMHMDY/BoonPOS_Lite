import 'package:go_router/go_router.dart';
import '../../features/pos/presentation/screens/pos_screen.dart';
import '../../features/license/presentation/screens/license_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/license', // يبدأ من فحص الترخيص دائماً
  routes: [
    GoRoute(
      path: '/license',
      name: 'license',
      builder: (context, state) => const LicenseScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const PosScreen(),
    ),
  ],
);