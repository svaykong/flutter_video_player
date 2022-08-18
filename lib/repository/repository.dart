import 'dart:convert' as json show jsonDecode;

// import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../models/video_model.dart';
import '../utill/custom_extension.dart';
import '../constants.dart';

class Repository {
  final String _url = 'videos/';

  Future<List<Video>> fetchListVideos() async {
    // ---  http  -----
    // creating url reference
    Uri uri;

    // creating client instance from http
    http.Client client = http.Client();

    // creating response instance from http
    http.Response response;

    // parsing video url
    uri = Uri.parse("$HOST$IP3:$PORT/$BASE_URL/$_url");
    log("uri :: $uri");

    // making request to the network
    response = await client.get(uri); // .timeout(const Duration(seconds: 5));
    log("response body :: ${response.body}");

    if (response.body.contains('"message":"Not found"')) {
      return Future.error("An error occurred ...");
    }
    // response body is a response string
    final listVideos = (json.jsonDecode(response.body) as List).map((element) => Video.fromJson(element)).toList();
    log("listVideos :: ${listVideos.length}");
    // ----- http ------

    return listVideos;
  }  
}

//   Future<List<Video>> _fetchVideos() async {
//   // getting list of videos from internet
//   for (var video in listVideosPage) {
//     try {
//       BaseOptions options = BaseOptions(
//         // baseUrl: '',
//         // connectTimeout: 30000, //30 seconds
//         // receiveTimeout: 30000,
//         responseType: ResponseType.bytes,
//       );

//       Dio dio = Dio(options);
//       await dio.get(video.imgURL);

//       try {
//         await dio.get(video.videoURL);
//         _videos = [..._videos, video];
//       } on DioError catch (e) {
//         log("fetch video exception 1...");
//         log(e.message);

//         // should retry
//         if (e.response!.statusCode == 504) {
//           try {
//             // request timeout
//             log("request timeout, request again...");

//             await dio.get(video.videoURL);
//             _videos = [..._videos, video];
//           } on DioError catch (e) {
//             log("fetch video exception 2...");
//             log(e.message);
//             return Future.error(e.message);
//           }
//         } else {
//           return Future.error(e.message);
//         }
//       }
//     } on DioError catch (e) {
//       log("fetch img exception...");
//       log(e.message);
//       return Future.error(e.message);
//     }
//   }

//   return _videos;
// }
