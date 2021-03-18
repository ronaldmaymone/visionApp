import 'package:flutter/material.dart';
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
              return _.list != null ? ListView.builder(
                itemCount: _.list.files.length,
                itemBuilder: (BuildContext context, int index){
                  return ListTile(
                    leading: Icon(Icons.file_download_done),
                    title: Text(_.list.files[index].name),
                  );
                }
              ) : Center(child: CircularProgressIndicator(),);
            },
        )
      ),
    );
  }
}
