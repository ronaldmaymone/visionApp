
import 'package:get/get.dart';
import 'package:vision_app/app/controllers/home_controller.dart';

class HomeBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}