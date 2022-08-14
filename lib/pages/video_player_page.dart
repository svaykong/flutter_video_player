import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../models/model.dart';
import '../utill/custom_extension.dart';

class VideoPlayerPage extends StatefulWidget {
  final Video video;
  final Future<void> videoPlayerCtrFuture;
  final VideoPlayerController videoPlayerCtr;
  const VideoPlayerPage({
    Key? key,
    required this.video,
    required this.videoPlayerCtrFuture,
    required this.videoPlayerCtr,
  }) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late Future<void> _initializeVideoPlayerFuture;
  late ChewieController _chewieCtr;

  @override
  void initState() {
    // call parent class initialize first before others initialize -> super.initState()
    super.initState();

    // initialize videoPlayerController
    _initializeVideoPlayerFuture = widget.videoPlayerCtrFuture;

    // initialize ChewieController
    _chewieCtr = ChewieController(
      videoPlayerController: widget.videoPlayerCtr,
      autoPlay: true,
      looping: true,
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ],
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
    )..autoInitialize;
  }

  @override
  void dispose() {
    // clean up ChewieController instance
    _chewieCtr.dispose();

    // Notice!!!
    // cannot call widget.videoPlayerCtr.dispose
    // clean up VideoPlayerCtroller instance
    widget.videoPlayerCtr.dispose();

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
          if (_chewieCtr.isPlaying) {
            await _chewieCtr.pause();
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
      future: Future.wait([
        _initializeVideoPlayerFuture,
        Future.delayed(const Duration(seconds: 2)),
      ]),
      builder: (context, snapshot) {
        return AspectRatio(
          aspectRatio: snapshot.connectionState == ConnectionState.done ? _chewieCtr.aspectRatio ?? 16 / 9 : 16 / 9,
          child:
              (snapshot.connectionState == ConnectionState.done) ? Chewie(controller: _chewieCtr) : _getStackWidget(),
        );
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

  Widget _getAspect() {
    return AspectRatio(
      aspectRatio: _chewieCtr.aspectRatio ?? 16 / 9,
      child: Chewie(controller: _chewieCtr),
    );
  }
}
