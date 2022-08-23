import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';

import '../models/model.dart';
import '../utill/util.dart';

class VideoPlayerPage extends StatefulWidget {
  final Video video;
  final ChewieController chewieCtr;
  const VideoPlayerPage({
    Key? key,
    required this.video,
    required this.chewieCtr,
  }) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late Future<void> _future;

  @override
  void initState() {
    super.initState(); //Super should be called at the very beginning of init

    _future = Future.delayed(const Duration(milliseconds: 500), () {
      widget.chewieCtr.videoPlayerController.addListener(checkVideo);
    });
  }

  @override
  void dispose() {
    // clean up ChewieController
    widget.chewieCtr.dispose();

    // remove checkVideo listener
    widget.chewieCtr.videoPlayerController.removeListener(checkVideo);

    super.dispose(); //Super should be called at the very end of dispose
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          "pressed back button called in WillPopScope ...".log();

          // stop chewieController playing state
          if (widget.chewieCtr.isPlaying) {
            await widget.chewieCtr.pause();
            await widget.chewieCtr.seekTo(Duration.zero);
          }

          if (!mounted) {
            return true;
          }

          Navigator.of(context).pop();

          return true;
        },
        child: SafeArea(
          child: _getBody(context),
        ),
      ),
    );
  }

  // Use a FutureBuilder to display a loading spinner while waiting for
  // the VideoPlayerController to finish initializing.
  Widget _getBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.video.title,
        ),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return _getStackWidget();
            case ConnectionState.done:
              return AspectRatio(
                aspectRatio: widget.chewieCtr.aspectRatio ?? 16 / 9,
                child: Chewie(controller: widget.chewieCtr),
              );
          }
        },
      ),
    );
  }

  Widget _getStackWidget() {
    return Stack(
      children: [
        Hero(
          tag: widget.video.id,
          child: Image.network(widget.video.imgURL),
        ),
        const Positioned.fill(
          child: Align(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  void checkVideo() {
    // Implement your calls inside these conditions' bodies :
    if (widget.chewieCtr.videoPlayerController.value.position == const Duration(seconds: 0, minutes: 0, hours: 0)) {
      'video Started'.log();
    }

    
  }
}
