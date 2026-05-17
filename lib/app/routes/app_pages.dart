import 'package:get/get.dart';

import '../modules/calculator/bindings/calculator_binding.dart';
import '../modules/calculator/views/calculator_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/new_installation/bindings/new_installation_binding.dart';
import '../modules/new_installation/views/new_installation_view.dart';
import '../modules/new_report/bindings/new_report_binding.dart';
import '../modules/new_report/views/new_report_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/payment_detail/bindings/payment_detail_binding.dart';
import '../modules/payment_detail/views/payment_detail_view.dart';
import '../modules/payment_history/bindings/payment_history_binding.dart';
import '../modules/payment_history/views/payment_history_view.dart';
import '../modules/petugas_dashboard/bindings/petugas_dashboard_binding.dart';
import '../modules/petugas_dashboard/views/petugas_dashboard_view.dart';
import '../modules/petugas_input_meter/bindings/petugas_input_meter_binding.dart';
import '../modules/petugas_input_meter/views/petugas_input_meter_view.dart';
import '../modules/petugas_meter_detail/bindings/petugas_meter_detail_binding.dart';
import '../modules/petugas_meter_detail/views/petugas_meter_detail_view.dart';
import '../modules/petugas_pelanggan/bindings/petugas_pelanggan_binding.dart';
import '../modules/petugas_pelanggan/views/petugas_pelanggan_view.dart';
import '../modules/petugas_pengaduan/bindings/petugas_pengaduan_binding.dart';
import '../modules/petugas_pengaduan/views/petugas_pengaduan_view.dart';
import '../modules/petugas_profile/bindings/petugas_profile_binding.dart';
import '../modules/petugas_profile/views/petugas_profile_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/reports/bindings/reports_binding.dart';
import '../modules/reports/views/reports_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: Routes.REPORTS,
      page: () => const ReportsView(),
      binding: ReportsBinding(),
    ),
    GetPage(
      name: Routes.NEW_REPORT,
      page: () => const NewReportView(),
      binding: NewReportBinding(),
    ),
    GetPage(
      name: Routes.NEW_INSTALLATION,
      page: () => const NewInstallationView(),
      binding: NewInstallationBinding(),
    ),
    GetPage(
      name: Routes.CALCULATOR,
      page: () => const CalculatorView(),
      binding: CalculatorBinding(),
    ),
    GetPage(
      name: Routes.PAYMENT_HISTORY,
      page: () => const PaymentHistoryView(),
      binding: PaymentHistoryBinding(),
    ),
    GetPage(
      name: Routes.PAYMENT_DETAIL,
      page: () => const PaymentDetailView(),
      binding: PaymentDetailBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.PETUGAS_DASHBOARD,
      page: () => const PetugasDashboardView(),
      binding: PetugasDashboardBinding(),
    ),
    GetPage(
      name: _Paths.PETUGAS_PELANGGAN,
      page: () => const PetugasPelangganView(),
      binding: PetugasPelangganBinding(),
    ),
    GetPage(
      name: _Paths.PETUGAS_METER_DETAIL,
      page: () => const PetugasMeterDetailView(),
      binding: PetugasMeterDetailBinding(),
    ),
    GetPage(
      name: _Paths.PETUGAS_INPUT_METER,
      page: () => const PetugasInputMeterView(),
      binding: PetugasInputMeterBinding(),
    ),
    GetPage(
      name: _Paths.PETUGAS_PENGADUAN,
      page: () => const PetugasPengaduanView(),
      binding: PetugasPengaduanBinding(),
    ),
    GetPage(
      name: _Paths.PETUGAS_PROFILE,
      page: () => const PetugasProfileView(),
      binding: PetugasProfileBinding(),
    ),
  ];
}
