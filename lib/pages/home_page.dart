import 'package:flutter/material.dart';

import 'list_videos_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Videos"),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: ListVideosPage(),
      ),
    );
  }
}
