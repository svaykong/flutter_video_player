import 'dart:developer' show log;

import 'package:flutter/material.dart';

class DartSyntax extends StatelessWidget {
  DartSyntax({Key? key}) : super(key: key);

  int? num;

  @override
  Widget build(BuildContext context) {
    log("dart_syntax build context...");

    log("num :: [ $num ]");

    num = 3;
    log("num :: [ $num ]");

    return const Scaffold(
      body: Center(
        child: Text(""),
      ),
    );
  }
}
