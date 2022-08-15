import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';

import '../models/model.dart';
import '../utill/custom_extension.dart';

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
    // call parent class initialize first before others initialize -> super.initState()
    super.initState();

    _future = Future.delayed(const Duration(seconds: 5), () {
      setState(() {});

      widget.chewieCtr.play();
      widget.chewieCtr.setLooping(true);
    });
  }

  @override
  void dispose() {
    // clean up ChewieController instance
    widget.chewieCtr.dispose();

    // call parent class clean up at the end -> super.dispose()
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          log("pressed back button called ...");

          // stop chewieController playing state
          if (widget.chewieCtr.isPlaying) {
            await widget.chewieCtr.pause();
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
    return FutureBuilder(
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
    );
  }

  Widget _getStackWidget() {
    log("_getStackWidget called ...");
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
}
