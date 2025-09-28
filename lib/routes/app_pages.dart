import 'package:get/get.dart';
import 'package:sabeelapp/presentation/bindings/surah_detail_binding.dart';
import 'package:sabeelapp/presentation/bindings/home_binding.dart';
import 'package:sabeelapp/presentation/bindings/dashboard_binding.dart';
import 'package:sabeelapp/presentation/bindings/ai_service_binding.dart';
import '../presentation/views/home_view.dart';
import '../presentation/views/journey_view.dart';
import '../presentation/views/onboarding_view.dart';
import '../presentation/views/dashboard_view.dart';
import '../presentation/views/quran_view.dart';
import '../presentation/views/surah_detail_view.dart';
import '../presentation/views/response_page.dart';
import '../core/auth_middleware.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(name: Routes.JOURNEY, page: () => const JourneyView()),
    GetPage(name: Routes.ONBOARDING, page: () => const OnboardingView()),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardView(),
      binding: BindingsBuilder(() {
        DashboardBinding().dependencies();
        AIServiceBinding().dependencies();
      }),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.QURAN,
      page: () => const QuranView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.SURAH_DETAIL,
      page: () => const SurahDetailView(),
      binding: SurahDetailBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.RESPONSE,
      page: () => const ResponsePage(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
