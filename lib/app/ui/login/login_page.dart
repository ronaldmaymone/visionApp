import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_app/app/controllers/login_controller.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Page')),
      body: Container(
        child: GetX<LoginController>(
            init: LoginController(),
            builder: (_) {
              return Center(
                child: SignInButton(
                  Buttons.Google,
                  onPressed: () {
                    _.logInWithGoogle();
                  },
                ),
              );
            }),
      ),
    );
  }
}
