import 'dart:io';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vision_app/app/data/repository/user_repository.dart';
import 'package:vision_app/app/routes/app_pages.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;


class HomeController extends GetxController {
  final UserRepository userRepository;
  drive.FileList list;

  HomeController(this.userRepository);
  // final _obj = ''.obs;
  // set obj(value) => _obj.value = value;
  // get obj => _obj.value;
  @override
  void onInit() async {
    await loadFromDrive();
    super.onInit();
  }

  isLogged(){
    return userRepository.isLogged();
  }
  handlePopMenuClick(String value) async {
    switch (value) {
      case 'Sair':
        if(userRepository.logoff()){
          //TODO: Delete database.
          await logOutFromGoogle();
          Get.offAllNamed(Routes.SPLASH);
        }else{
          Get.snackbar("Erro inesperado ao sair", "Tente novamente em instantes");
        }
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
        Get.snackbar("Função em desenvolvimento", "Tente em versões posteriores");
        break;
    }
  }

  loadFromDrive() async {
    // print("ACCOUNT on GET => ${Get.find<GoogleSignInAccount>()}");
    final googleSignIn = signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveReadonlyScope]);
    final signIn.GoogleSignInAccount account = await googleSignIn.signIn();
    final authHeaders = await account.authHeaders;
    // final authHeaders = await Get.find<GoogleSignInAccount>().authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);
    final folderName = 'Legado';
    // var client = authenticateClient;
    // var drive = driveApi
    driveApi.files.list(q: "mimeType contains 'video/' and starred",spaces: 'drive',supportsAllDrives: true).then((value) async {
      list = value;
      update();
      for (var i = 0; i < list.files.length; i++) {
        print("Id: ${list.files[i].id} File Name:${list.files[i].name}");

        driveApi.files.get("${list.files[i].id}",downloadOptions: drive.DownloadOptions.FullMedia).then((value) async {
          final directory = await getApplicationDocumentsDirectory();
          // final directory2 = await getDownloadsDirectory();
          final saveFile = File('${directory.path}/${list.files[i].name}');
          List<int> dataStore = [];
          drive.Media file = value as drive.Media;
          file.stream.listen((data) {
            print("DataReceived: ${data.length}");
            dataStore.insertAll(dataStore.length, data);
          }, onDone: () {
            print("Task Done");
            saveFile.writeAsBytes(dataStore);
            print("File saved at ${saveFile.path}");
          }, onError: (error) {
            print("Some Error");
          });
        });

      }
    });

  }

  downloadAndSaveFile(){

  }

  logOutFromGoogle() async {
    final googleSignIn = signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveReadonlyScope]);
    await googleSignIn.signOut();
  }

  // Future<void> _downloadGoogleDriveFile(String fName, String gdID) async {
  //   var client = authenticateClient;
  //   var drive = driveApi
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

  // Future<void> _listGoogleDriveFiles() async {
  //   var client = GoogleAuthClient(authHeaders);
  //   var drive = ga.DriveApi(client);
  //   drive.files.list(spaces: 'appDataFolder').then((value) {
  //     setState(() {
  //       list = value;
  //     });
  //     for (var i = 0; i < list.files.length; i++) {
  //       print("Id: ${list.files[i].id} File Name:${list.files[i].name}");
  //     }
  //   });
  // }

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