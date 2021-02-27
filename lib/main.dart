import 'package:flutter/material.dart'; 
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';
import 'app/ui/theme/app_theme.dart'; 

void main() async {
  await GetStorage.init();
  runApp(GetMaterialApp(       
    debugShowCheckedModeBanner: false,       
    initialRoute: Routes.SPLASH,       
    theme: appThemeData,       
    defaultTransition: Transition.fade,       
    getPages: AppPages.pages,
  ));       
}