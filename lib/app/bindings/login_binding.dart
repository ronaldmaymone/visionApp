import 'package:get/get.dart';
import 'package:vision_app/app/controllers/login_controller.dart';
import 'package:vision_app/app/data/repository/user_repository.dart';

class LoginBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(LoginController(UserRepository()));
  }
}