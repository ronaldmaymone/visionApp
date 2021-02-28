import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';

class UserRepository {
  final storage = Get.find<GetStorage>();

  UserRepository();

  isLogged(){
    return storage.read("isLogged")??false;
  }

  login(){
    try{
      storage.write("isLogged", true);
    }
    catch(e){
      print("ERROR SAVING LOGIN: $e");
    }
  }

  logoff(){
    try{
      storage.write("isLogged", false);
    }
    catch(e){
      print("ERROR SAVING LOGOFF: $e");
    }
  }
  eraseAllUserInfo(){
    storage.erase();
  }
}

