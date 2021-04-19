import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:vision_app/app/controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Página Principal'), centerTitle: true, actions: [
      //   PopupMenuButton<String>(
      //     onSelected: Get.find<HomeController>().handlePopMenuClick,
      //     itemBuilder: (BuildContext context) {
      //       return {'Sobre', 'Configurações', Get.find<HomeController>().isLogged() ? 'Sair' : 'Entrar'}.map((String choice) {
      //         return PopupMenuItem<String>(
      //           value: choice,
      //           child: Text(choice),
      //         );
      //       }).toList();
      //     },
      //   ),
      // ],),
      body: Container(
        child: GetBuilder<HomeController>(
            builder: (_) {
              print("STARTED GET BUILDER");
              return _.videoPlayerController != null && _.videoPlayerController.value.isInitialized ?
                GetX<HomeController>(
                    builder: (_){ print("RELOADED VIDEO WIDGET");return !_.loadingNextVideo ? AspectRatio(
                      aspectRatio: Get.width/Get.height,
                      child: VideoPlayer(
                        _.videoPlayerController,
                      ),
                    ):
                      Center(child: CircularProgressIndicator());
                  }
                ):
              GetX<HomeController>(builder:(_){ return Center(child: loadingWidget(_));});
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
