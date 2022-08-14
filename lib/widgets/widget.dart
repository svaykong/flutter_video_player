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

// Widget _getListView(BuildContext context, List<Video> videos) {
//   return ListView.builder(
//     padding: EdgeInsets.zero,
//     itemCount: videos.length,
//     itemBuilder: (context, index) {
//       final videoPlayerCtr = VideoPlayerController.network(videos[index].videoURL);
//       return FutureBuilder(
//         future: videoPlayerCtr.initialize(),
//         builder: ((context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.none:
//             case ConnectionState.waiting:
//             case ConnectionState.active:
//               return _getLoadingWidget();
//             case ConnectionState.done:
//               return AspectRatio(
//                 aspectRatio: videoPlayerCtr.value.aspectRatio,
//                 child: _getColumnWidget(videos[index], videoPlayerCtr),
//               );
//           }
//         }),
//       );
//     },
//   );
// }

// Widget _getColumnWidget(Video video, VideoPlayerController videoPlayerCtr) {
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.start,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Expanded(
//         child: GestureDetector(
//           onTap: () => Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => VideoPlayerPage(
//                 video: video,
//                 videoPlayerCtr: videoPlayerCtr,
//               ),
//             ),
//           ),
//           child: Hero(
//             tag: video.id,
//             child: Image.network(
//               video.imgURL,
//               height: MediaQuery.of(context).size.height * 0.5,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//       ),
//       Expanded(
//         child: Text(
//           video.title,
//           textAlign: TextAlign.start,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//         ),
//       ),
//     ],
//   );
// }

// Check internet connected
// RefreshIndicator _checkInternetConnected(BuildContext context) {
//   return RefreshIndicator(
//     onRefresh: () => Future.delayed(const Duration(seconds: 2), () {
//       Flushbar(
//         flushbarPosition: FlushbarPosition.TOP,
//         message: "The airplane mode is on, please check your internet.",
//         icon: Icon(
//           Icons.info_outline,
//           size: 28.0,
//           color: Colors.blue[300],
//         ),
//         duration: const Duration(seconds: 3),
//       ).show(context);
//     }),
//     child: Column(
//       children: [
//         Text(
//           "Display Snackbar...",
//           style: Theme.of(context).textTheme.headline5,
//         ),
//         Flexible(
//           child: ListView.builder(
//             itemBuilder: (context, index) => Card(child: Text("$index")),
//             itemCount: 100,
//           ),
//         ),
//       ],
//     ),
//   );
// }

