import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vision_app/app/controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Página Principal'), centerTitle: true, actions: [
        PopupMenuButton<String>(
          onSelected: Get.find<HomeController>().handlePopMenuClick,
          itemBuilder: (BuildContext context) {
            return {'Sobre', 'Configurações', Get.find<HomeController>().isLogged() ? 'Sair' : 'Entrar'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],),
      body: Container(
        child: GetBuilder<HomeController>(
            builder: (_) {
              print("STARTED GET BUILDER");
              return _.betterPlayerController != null ?
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: BetterPlayer(
                    controller: _.betterPlayerController,
                  ),
                ):
                  // AspectRatio(
                  //   aspectRatio: 16 / 9,
                  //   child: BetterPlayerPlaylist(
                  //       betterPlayerConfiguration: BetterPlayerConfiguration(autoPlay: true, fullScreenByDefault: true,allowedScreenSleep: false,autoDispose: false,deviceOrientationsAfterFullScreen: [DeviceOrientation.landscapeLeft]),
                  //       betterPlayerPlaylistConfiguration: BetterPlayerPlaylistConfiguration(initialStartIndex: 2,nextVideoDelay: Duration(milliseconds: 500)),
                  //       betterPlayerDataSourceList: _.dataSourceList),
                  // ):
                  GetX<HomeController>(builder:(_){ return Center(child: loadingWidget(_));});
              // return _.list != null ? ListView.builder(
              //   itemCount: _.list.files.length,
              //   itemBuilder: (BuildContext context, int index){
              //     return ListTile(
              //       leading: Icon(Icons.file_download_done),
              //       title: Text(_.list.files[index].name),
              //     );
              //   }
              // ) : Center(child: CircularProgressIndicator(),);
            },
        )
      ),
    );
  }
}

Widget loadingWidget(HomeController _){
  return _.loadedFromDownload ?  Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircularProgressIndicator(),
      SizedBox(height: 10),
      Text("Baixando vídeo ${_.currentVideoBeeingDownloaded} de ${_.totalToBeDownloaded}",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0))
    ],
  ) :
  Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircularProgressIndicator(),
      SizedBox(height: 10),
      Text("Verificando vídeos salvos...",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),)
    ],
  );

}
