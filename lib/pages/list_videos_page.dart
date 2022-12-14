import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:chewie/chewie.dart';

import 'page.dart';
import '../models/model.dart';
import '../repository/repository.dart';
import '../widgets/widget.dart';
import '../utill/util.dart';

class ListVideosPage extends StatefulWidget {
  const ListVideosPage({Key? key}) : super(key: key);

  @override
  State<ListVideosPage> createState() => _ListVideosPageState();
}

class _ListVideosPageState extends State<ListVideosPage> {
  late Repository _repository;
  late Future<List<Video>> _fetchVideosFuture;
  List<Video> _listVideos = [];

  @override
  void initState() {
    super.initState(); //Super should be called at the very beginning of init

    // create repository instance
    _repository = Repository();

    // fetch list videos from future
    _fetchVideosFuture = _repository.fetchListVideos();
  }

  @override
  void dispose() {
    // clean up VideoplayerController
    if (_listVideos.isNotEmpty) {
      _listVideos.map((video) => video.videoCtr.dispose());
    }

    super.dispose(); //Super should be called at the very end of dispose
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
              final messageError = snapshot.error.toString();
              if (messageError.contains("check internet connection") || messageError.contains("Connection timed out")) {
                return getSnapshotErrorWidget(context, messageError, () async {
                  "Retry button click ...".log();

                  // check internet connect first before called retry
                  bool hasInternet = await checkInternetConnect();

                  if (!mounted) {}

                  // No internet connection alert the snackbar on the top
                  if (hasInternet == false) {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        backgroundColor: Colors.black45,
                        content: const Text(
                          'No internet connection',
                          textAlign: TextAlign.center,
                        ),
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height - 125,
                          right: 20,
                          left: 20,
                        ),
                      ));
                  } else {
                    // if internet has connected try again
                    setState(() {
                      // import call again to make it trigger
                      _fetchVideosFuture = _repository.fetchListVideos();
                    });
                  }
                });
              }
              return getSnapshotErrorWidget(context, messageError, null);
            }

            final data = snapshot.data;
            if (data == null) {
              return const Center(
                child: Text("No data ..."),
              );
            }

            _listVideos = data;

            return _getListViewBuilder(context, _listVideos);
        }
      }),
    );
  }

  Widget _getListViewBuilder(BuildContext context, List<Video> videos) {
    return ListView.builder(
      itemCount: videos.length,
      itemBuilder: ((context, index) {
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
                    tag: videos[index].id,
                    child: Image.network(
                      videos[index].imgURL,
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
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => VideoPlayerPage(
                                  video: videos[index],
                                  chewieCtr: ChewieController(
                                    videoPlayerController: videos[index].videoCtr,
                                    showControlsOnInitialize: false,
                                    autoPlay: true,
                                    looping: true,
                                    deviceOrientationsOnEnterFullScreen: [
                                      DeviceOrientation.landscapeRight,
                                      DeviceOrientation.landscapeLeft,
                                    ],
                                    deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
                                  )..autoInitialize,
                                ),
                              ),
                            );
                          },
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
                videos[index].title,
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
      }),
    );
  }
}
