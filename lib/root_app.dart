import 'package:flutter/material.dart';

// import 'dart_programming/dart_syntax/dart_syntax.dart';

import 'pages/home_page.dart';

class RootApp extends StatelessWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // In the BuildContext
    // Before the app start we set the screen orientation of the app to portrait prevent user rotate to lanscape mode
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Video Player',
      theme: ThemeData(
        // brightness: Brightness.dark,
        // bottomNavigationBarTheme: const BottomNavigationBarThemeData(selectedItemColor: Colors.white),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
          accentColor: Colors.redAccent,
        ),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

