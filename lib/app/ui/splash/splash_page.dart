import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SplashPage extends StatelessWidget {
  /// if you need you can pass the tag for
  /// Get.find<AwesomeController>(tag:"myTag");
  SplashPage({Key key}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(Colors.blue.value),
                    Color(Colors.white.value)
                  ],
                )
            ),
          ),
          Center(
            child: Container(
              child: Text("APP LOGO HERE"),
              // child: Image.asset(
              //   "assets/images/AraciLabLogo.png",
              //   alignment: Alignment.center,
              // ),
              padding: EdgeInsets.all(100),
            ),
          ),
        ],
      ),
    );
  }
}
