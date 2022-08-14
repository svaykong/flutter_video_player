import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';

import '../constants.dart';

@immutable
class Video extends Equatable {
  final String id; // DateTime.now().millisecondsSinceEpoch.toString();
  final String title;
  final String videoURL;
  final String imgURL;
  final String author;

  const Video({
    required this.id,
    required this.title,
    required this.videoURL,
    required this.imgURL,
    required this.author,
  });

  @override
  List<Object?> get props => [id, title, videoURL, imgURL, author];

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json["id"],
      title: json["title"],
      videoURL: "$HOST$IP3:$PORT/$BASE_URL${json["video_url"]}",
      imgURL: "$HOST$IP3:$PORT/$BASE_URL${json["img_url"]}",
      author: json["author"],
    );
  }
}
