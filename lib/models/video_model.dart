import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';

import '../constants.dart';

@immutable
class Video extends Equatable {
  final String id; // DateTime.now().millisecondsSinceEpoch.toString();
  final String title;
  final String videoURL;
  final String imgURL;
  final String author;
  final VideoPlayerController videoCtr;

  const Video({
    required this.id,
    required this.title,
    required this.videoURL,
    required this.imgURL,
    required this.author,
    required this.videoCtr,
  });

  @override
  List<Object?> get props => [id, title, videoURL, imgURL, author];

  factory Video.fromJson(Map<String, dynamic> json, {ip = IP3}) {
    final videoURL = "$HOST$ip:$PORT/$BASE_URL${json["video_url"]}";
    final imgURL = "$HOST$ip:$PORT/$BASE_URL${json["img_url"]}";
    return Video(
      id: json["id"],
      title: json["title"],
      videoURL: videoURL,
      imgURL: imgURL,
      author: json["author"],
      videoCtr: VideoPlayerController.network(videoURL)..initialize(),
    );
  }
}
