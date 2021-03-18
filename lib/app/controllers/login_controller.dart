import 'package:get/get.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:vision_app/app/data/repository/user_repository.dart';
import 'package:vision_app/app/routes/app_pages.dart';
import 'package:http/http.dart' as http;


class LoginController extends GetxController {
  final UserRepository userRepository;


  LoginController(this.userRepository);
  // final _obj = ''.obs;
  // set obj(value) => _obj.value = value;
  // get obj => _obj.value;
  final _busy = false.obs;
  set busy(value) => _busy.value = value;
  get busy => _busy.value;
  // var driveApi;
  // @override
  // void onInit() async {
  //
  //   super.onInit();
  // }

  logInWithGoogle() async {
    try{
      busy = true;
      final googleSignIn = signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveReadonlyScope]);
      final signIn.GoogleSignInAccount account = await googleSignIn.signIn();
      if (account!=null){
        print("User account $account");
        // final authHeaders = await account.authHeaders;
        // final authenticateClient = GoogleAuthClient(authHeaders);
        // driveApi = drive.DriveApi(authenticateClient);
        userRepository.login();
        Get.put(account);
        // userRepository.saveInformation("account", account);
        Get.offNamed(Routes.HOME);
      }
      else{
        Get.snackbar("Erro ao logar!", "Sua conta não retornou. Verifique as permissões concedidas e tente novamente.");
      }
      busy = false;
    }
    catch (e){
      Get.snackbar("Erro inesperado ao logar", "Tente novamente em instantes");
      print("ERROR ON GOOGLE SIGN IN $e");
    }

  }

}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;

  final http.Client _client = new http.Client();

  GoogleAuthClient(this._headers);

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }

  @override
  Future<http.Response> head(Object url, {Map<String, String> headers}) =>
      super.head(url, headers: headers..addAll(_headers));
}
