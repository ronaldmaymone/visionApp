import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_app/app/controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Página Principal')),
      body: Container(
        child: GetX<HomeController>(
            builder: (_) {
              return Center(
                child: Text("Vídeos em full screen"),
              );
            }),
      ),
    );
  }
}
