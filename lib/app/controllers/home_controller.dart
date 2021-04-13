import 'dart:io' as io;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:vision_app/app/data/repository/user_repository.dart';
import 'package:vision_app/app/routes/app_pages.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:wakelock/wakelock.dart';



class HomeController extends GetxController {
  final UserRepository userRepository;
  drive.FileList list;
  List<String> fileNames = <String>[];
  List<io.FileSystemEntity> listOFFilesToBePlayed;

  // var directory;
  // final directory = "/storage/emulated/0/Android/data/com.example.vision_app/files";
  var directory2;
  final _totalToBeDownloaded = 0.obs;
  final _currentVideoBeeingDownloaded = 1.obs;
  int downloadedVideos = 0;
  RxBool _loadedFromDownload = false.obs;
  int currentVideoIndex = 0;
  RxBool _loadingNextVideo = false.obs;


  VideoPlayerController videoPlayerController;

  ///Getters and Setters of obs variables
  set totalToBeDownloaded(value) => _totalToBeDownloaded.value = value;
  get totalToBeDownloaded => _totalToBeDownloaded.value;
  set currentVideoBeeingDownloaded(value) => _currentVideoBeeingDownloaded.value = value;
  get currentVideoBeeingDownloaded => _currentVideoBeeingDownloaded.value;
  set loadedFromDownload(value) => _loadedFromDownload.value = value;
  get loadedFromDownload => _loadedFromDownload.value;
  set loadingNextVideo(value) => _loadingNextVideo.value = value;
  get loadingNextVideo => _loadingNextVideo.value;

  ///____________________________________
  HomeController(this.userRepository);
  // final _obj = ''.obs;
  // set obj(value) => _obj.value = value;
  // get obj => _obj.value;
  @override
  void onInit() async {
    directory2 = await getApplicationSupportDirectory();
    initialize();
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
    final googleSignIn = signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveReadonlyScope]);
    final signIn.GoogleSignInAccount account = await googleSignIn.signIn();
    final authHeaders = await account.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);
    // var client = authenticateClient;
    // var drive = driveApi
    // list = await driveApi.files.list(q: "mimeType contains 'video/' and starred",spaces: 'drive',supportsAllDrives: true);
    list = await driveApi.files.list(q: "name contains '[APP-Download]'",spaces: 'drive',supportsAllDrives: true);
    // driveApi.files.list(q: "mimeType contains 'video/' and starred",spaces: 'drive',supportsAllDrives: true).then((value) async {
      // list = value;
      // update();

    for (dynamic _file in list.files){
      fileNames.add(_file.name);
    }

    List listOFFiles = io.Directory("${directory2.path}").listSync();
    print("LIST OF FILES ON DISK=> $listOFFiles");
    print("LIST OF FILES FROM DRIVE => $fileNames");
    filterFilesAlreadyDownloaded(listOFFiles, fileNames);
    totalToBeDownloaded = fileNames.length;

    for (var i = 0; i < fileNames.length; i++) {
      loadedFromDownload = true;
      print("I'll download this one = > Id: ${list.files[i].id} File Name:${list.files[i].name}");


      driveApi.files.get("${list.files[i].id}",downloadOptions: drive.DownloadOptions.FullMedia).then((value) async {

        final saveFile = io.File('${directory2.path}/${list.files[i].name}');
        List<int> dataStore = [];
        drive.Media file = value as drive.Media;
        file.stream.listen((data) {
          // print("DataReceived: ${data.length}");
          dataStore.insertAll(dataStore.length, data);
        }, onDone: () async {
          downloadedVideos++;
          if(currentVideoBeeingDownloaded < totalToBeDownloaded)currentVideoBeeingDownloaded++;
          print("Task Done");
          // fileNames.add(list.files[i].name);
          await saveFile.writeAsBytes(dataStore).whenComplete(() {
            print("File saved at ${saveFile.path}");
            if (downloadedVideos >= fileNames.length){
              createController();
            }
          });
        }, onError: (error) {
          print("ERROR SAVING FILE: $error");
        });
      });

    }
    if(!loadedFromDownload)createController();
    // });
  }


  initialize() async{
    setScreenConfigs();
    await loadFromDrive();
  }

  logOutFromGoogle() async {
    final googleSignIn = signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveReadonlyScope]);
    await googleSignIn.signOut();
  }

  void createController() async {
    listOFFilesToBePlayed = io.Directory("${directory2.path}").listSync();
    print("CREATING CONTROLLER @@@@");
    print("FULL PATH TO THE VIDEO => ${listOFFilesToBePlayed[currentVideoIndex].path}");
    io.File videoFile = io.File("${listOFFilesToBePlayed[currentVideoIndex].path}");
    videoPlayerController = VideoPlayerController.file(videoFile);
    videoPlayerController.addListener(_checkEnd);
    await videoPlayerController.initialize().whenComplete(() {
      videoPlayerController.setLooping(false);
      videoPlayerController.play();
    });
    print("TOTAL DURATION = ${videoPlayerController.value.duration}");
    update();
  }

  void filterFilesAlreadyDownloaded(List onDisk, List onDrive) {
    List<String> filesToBeDeleted = <String>[];
    for (dynamic _path in onDisk){
      for (String fileName in onDrive){
        if(_path.path.toString().contains(fileName)){
          filesToBeDeleted.add(fileName);

        }
      }
    }
    for (String deleteNames in filesToBeDeleted){
      fileNames.remove(deleteNames);
    }
  }

  void loadNextVideo(List<io.FileSystemEntity> list) async{
    print("WILL PLAY THIS ${list[currentVideoIndex].path}");
    io.File vFile = io.File("${list[currentVideoIndex].path}");
    final old = videoPlayerController;
    videoPlayerController = VideoPlayerController.file(vFile);
    videoPlayerController.initialize().whenComplete(() {
      old?.dispose();
      videoPlayerController.addListener(_checkEnd);
      videoPlayerController.setLooping(false);
      videoPlayerController.play();
      loadingNextVideo = false;
    });

    // update();
  }

  _checkEnd() {
    print("I'm LISTENING");
    if(videoPlayerController.value.position >= videoPlayerController.value.duration){
      loadingNextVideo = true;
      videoPlayerController.removeListener(_checkEnd);
      print("VIDEO ENDED!@@@@@@@@@@@@");
      if(currentVideoIndex<listOFFilesToBePlayed.length-1){
        currentVideoIndex++;
      }else{
        currentVideoIndex = 0;
      }
      loadNextVideo(listOFFilesToBePlayed);
    }
  }

  void setScreenConfigs() async{
    await SystemChrome.setEnabledSystemUIOverlays([]);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    Wakelock.enable();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }
  @override
  void onClose() {
    videoPlayerController.dispose();
    super.onClose();
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