import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vision_app/app/controllers/login_controller.dart';
import 'package:vision_app/app/controllers/splash_controller.dart';
import 'package:vision_app/app/data/repository/user_repository.dart';

class SplashBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(GetStorage(), permanent: true);
    Get.put(SplashController(repository: UserRepository()));
  }
}