import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
              child: SvgPicture.asset(
                "assets/images/LogoVision.svg",
                height: 100,
                width: 100,
                alignment: Alignment.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
