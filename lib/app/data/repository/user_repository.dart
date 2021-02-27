import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';

class UserRepository {
  final storage = Get.find<GetStorage>();

  UserRepository();

  isLogged(){
    return storage.read("isLogged");
  }
}

