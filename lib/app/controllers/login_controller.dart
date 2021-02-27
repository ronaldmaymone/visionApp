import 'package:get/get.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;

class LoginController extends GetxController {

  // final _obj = ''.obs;
  // set obj(value) => _obj.value = value;
  // get obj => _obj.value;

  // @override
  // void onInit() async {
  //
  //   super.onInit();
  // }

  logInWithGoogle() async {
    final googleSignIn = signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveReadonlyScope]);
    final signIn.GoogleSignInAccount account = await googleSignIn.signIn();
    print("User account $account");
  }

}
