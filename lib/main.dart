import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MemoShareApp());
}

class MemoShareApp extends StatelessWidget {
  const MemoShareApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: SizedBox()
    );
  }
}

