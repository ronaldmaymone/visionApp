import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_app/app/controllers/login_controller.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<LoginController>();
    return Scaffold(
      appBar: AppBar(title: Text('Logue na Conta Google'), centerTitle: true,),
      body: Obx(()=> controller.busy ? Center(child: CircularProgressIndicator(),) :
        Center(
          child: Container(
            width: 200,
            height: 50,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: SignInButton(
                Buttons.GoogleDark,
                onPressed: (){
                  controller.logInWithGoogle();
                },
              ),
            ),
          ),
        )
      )
      // body: Container(
      //   child: GetBuilder<LoginController>(
      //       init: LoginController(),
      //       builder: (_) {
      //         return Center(
      //           child: SignInButton(
      //             Buttons.Google,
      //             onPressed: () {
      //               _.logInWithGoogle();
      //             },
      //           ),
      //         );
      //       }),
      // ),
    );
  }
}
