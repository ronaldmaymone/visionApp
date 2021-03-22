import 'dart:async';
import 'package:get/get.dart';
import 'package:vision_app/app/data/repository/user_repository.dart';
import 'package:vision_app/app/routes/app_pages.dart';

class SplashController extends GetxController {

  final UserRepository repository;
  SplashController({this.repository});
  // final _obj = ''.obs;
  // set obj(value) => _obj.value = value;
  // get obj => _obj.value;

  @override
  void onInit() {
    Future.delayed(Duration(seconds: 3), chooseNextPage);
    super.onInit();
  }

  chooseNextPage() {
    // Get.offNamed(Routes.LOGIN);
    Get.offNamed(repository.isLogged() ? Routes.HOME : Routes.LOGIN);
  }
}