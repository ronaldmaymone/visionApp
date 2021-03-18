import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';

class UserRepository {
  final storage = Get.find<GetStorage>();

  UserRepository();

  isLogged(){
    return storage.read("isLogged")??false;
  }

  saveInformation(String key, dynamic value){
    try{
      storage.write(key, value);
    }
    catch(e){
      print("ERROR SAVING $key: $e");
    }
  }

  getInformation(String key){
    return storage.read(key);
  }

  login(){
    try{
      storage.write("isLogged", true);
    }
    catch(e){
      print("ERROR SAVING LOGIN: $e");
    }
  }

  bool logoff(){
    try{
      storage.write("isLogged", false);
      return true;
    }
    catch(e){
      print("ERROR SAVING LOGOFF: $e");
      return false;
    }
  }
  eraseAllUserInfo(){
    storage.erase();
  }
}

