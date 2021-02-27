import 'package:get/get.dart';
import 'package:vision_app/app/bindings/splash_binding.dart';
import 'package:vision_app/app/ui/home/home_page.dart';
import 'package:vision_app/app/ui/splash/splash_page.dart';
import 'package:vision_app/app/bindings/home_binding.dart';
part './app_routes.dart';

abstract class AppPages {

  static final pages = [
    GetPage(name: Routes.SPLASH, page:()=> SplashPage(), binding: SplashBinding()),
    GetPage(name: Routes.HOME, page:()=> HomePage(), binding: HomeBinding()),
    GetPage(name: Routes.LOGIN, page:()=> HomePage(), binding: HomeBinding()),
  ];
}