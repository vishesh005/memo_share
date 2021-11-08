import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:memo_share/base/config.dart';
import 'package:memo_share/base/translations.dart';

void main() {
  runApp(const MemoShareApp());
}

class MemoShareApp extends StatelessWidget {
  const MemoShareApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: appName,
      home: const SizedBox(),
      routes: appRoutes,
      translations: AppTranslations(),
      onInit: (){

      },
      onDispose: (){

      },
    );
  }
}


