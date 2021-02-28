import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:vision_app/app/data/repository/user_repository.dart';
import 'package:vision_app/app/routes/app_pages.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as googleDrive;

class HomeController extends GetxController {
  final UserRepository userRepository;

  HomeController(this.userRepository);
  // final _obj = ''.obs;
  // set obj(value) => _obj.value = value;
  // get obj => _obj.value;
  @override
  void onInit() async {
    super.onInit();
  }

  isLogged(){
    return userRepository.isLogged();
  }
  handlePopMenuClick(String value) async {
    switch (value) {
      case 'Sair':
        await userRepository.logoff();
        //TODO: Delete database.
        Get.offAllNamed(Routes.SPLASH);
        break;
      // case 'Configurações':
      //   Get.snackbar("Função em desenvolvimento","",backgroundColor: Colors.lightGreen);
      //   break;
      // case 'Sobre':
      //   Get.toNamed(Routes.ABOUT);
      //   break;
      case 'Entrar':
        Get.toNamed(Routes.LOGIN);
        break;
      default:
        Get.snackbar("Função em desenvolvimento", "");
        break;
    }
  }

  // Future<void> _downloadGoogleDriveFile(String fName, String gdID) async {
  //   var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
  //   var drive = googleDrive.DriveApi(client);
  //   googleDrive.Media file = await drive.files
  //       .get(gdID, downloadOptions: googleDrive.DownloadOptions.FullMedia);
  //   print(file.stream);
  //
  //   final directory = await getExternalStorageDirectory();
  //   print(directory.path);
  //   final saveFile = File('${directory.path}/${new DateTime.now().millisecondsSinceEpoch}$fName');
  //   List<int> dataStore = [];
  //   file.stream.listen((data) {
  //     print("DataReceived: ${data.length}");
  //     dataStore.insertAll(dataStore.length, data);
  //   }, onDone: () {
  //     print("Task Done");
  //     saveFile.writeAsBytes(dataStore);
  //     print("File saved at ${saveFile.path}");
  //   }, onError: (error) {
  //     print("Some Error");
  //   });
  // }

}

// class GoogleAuthClient extends http.BaseClient {
//   final Map<String, String> _headers;
//
//   final http.Client _client = new http.Client();
//
//   GoogleAuthClient(this._headers);
//
//   Future<http.StreamedResponse> send(http.BaseRequest request) {
//     return _client.send(request..headers.addAll(_headers));
//   }
// }