import 'dart:convert' as json show jsonDecode;

import 'package:http/http.dart' as http;

import '../models/video_model.dart';
import '../utill/util.dart';
import '../constants.dart';

class Repository {
  final String _url = 'videos/';

  Future<List<Video>> fetchListVideos({String ip = IP4}) async {
    // should delayes some seconds
    await Future.delayed(const Duration(milliseconds: 500), () {});

    // ---  http  -----
    // creating url reference
    Uri uri;

    // creating client instance from http
    http.Client client = http.Client();

    // creating response instance from http
    http.Response response;

    // parsing video url
    uri = Uri.parse("$HOST$ip:$PORT/$BASE_URL/$_url");
    uri.log();

    List<Video> listVideos = [];

    try {
      // making request to the network
      response = await client.get(uri);
      "response body :: ${response.body}".log();

      if (response.body.contains('"message":"Not found"')) {
        return Future.error("An error occurred ...");
      }
      // response body is a response string
      listVideos = (json.jsonDecode(response.body) as List).map((element) => Video.fromJson(element, ip: ip)).toList();
      "listVideos :: ${listVideos.length}".log();
    } catch (error) {
      "error :: $error".log();
      if (error.toString().contains('Connection refused')) {
        return Future.error("Internal Server Error");
      }
      if (error.toString().contains("Network is unreachable")) {
        return Future.error("Please check internet connection");
      }
      return Future.error(error);
    }

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
