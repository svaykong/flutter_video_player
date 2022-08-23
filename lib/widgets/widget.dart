import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../models/video_model.dart';

Widget getLoadingStackWidget(Video video) {
  return Stack(
    children: [
      Hero(
        tag: video.id,
        child: Image.network(video.imgURL),
      ),
      const Positioned.fill(
        child: Align(
          child: CircularProgressIndicator(),
        ),
      ),
    ],
  );
}

Widget getLoadingWidget() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

Widget getSnapshotErrorWidget(BuildContext context, String messageError, VoidCallback? onRetryPressed) {
  if (messageError.contains("check internet connection") || messageError.contains("Connection timed out")) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Wrap(
            direction: Axis.vertical,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: const Icon(
                  Icons.wifi_off,
                  size: 62,
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "No internet connetion",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(text: "\n\n"),
                    TextSpan(
                      text: "Connect to internet and try again.",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(200, 40),
            ),
            onPressed: onRetryPressed,
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
  return Center(
    child: Text(messageError),
  );
}
