import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

import 'page.dart';
import '../models/model.dart';
import '../repository/repository.dart';
import '../widgets/widget.dart';
// import '../utill/custom_extension.dart';

class ListVideosPage extends StatefulWidget {
  const ListVideosPage({Key? key}) : super(key: key);

  @override
  State<ListVideosPage> createState() => _ListVideosPageState();
}

class _ListVideosPageState extends State<ListVideosPage> {
  late Repository _repository;
  late Future<List<Video>> _fetchVideosFuture;

  @override
  void initState() {
    super.initState();

    // create repository instance
    _repository = Repository();

    // fetch list videos from future
    _fetchVideosFuture = _repository.fetchListVideos();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Video>>(
      future: _fetchVideosFuture,
      builder: ((context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return getLoadingWidget();
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            }

            final listVideos = snapshot.data;
            if (listVideos == null) {
              return const Center(
                child: Text("No data ..."),
              );
            }

            return ListView.builder(
                itemCount: listVideos.length,
                itemBuilder: ((context, index) {
                  final chewieCtr = ChewieController(
                    videoPlayerController: VideoPlayerController.network(listVideos[index].videoURL)..initialize(),
                    deviceOrientationsOnEnterFullScreen: [
                      DeviceOrientation.landscapeRight,
                      DeviceOrientation.landscapeLeft,
                    ],
                    deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
                  )..autoInitialize;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 200.0,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Hero(
                              tag: listVideos[index].id,
                              child: Image.network(
                                listVideos[index].imgURL,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: CircleAvatar(
                                  radius: 30.0,
                                  backgroundColor: Colors.black26,
                                  child: IconButton(
                                    onPressed: () => Navigator.of(context)
                                        .push(
                                          MaterialPageRoute(
                                            builder: (context) => VideoPlayerPage(
                                              video: listVideos[index],
                                              chewieCtr: chewieCtr,
                                            ),
                                          ),
                                        )
                                        .then((value) => setState(() {})), // clear the detail screen when navigate pop
                                    icon: const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 30.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, top: 8.0),
                        child: Text(
                          listVideos[index].title,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                  );
                }));
        }
      }),
    );
  }
}
