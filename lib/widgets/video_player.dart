import 'package:flutter/material.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class YoutubeVideoPlayer extends StatefulWidget {
//   final String url;
//
//   const YoutubeVideoPlayer({super.key, required this.url});
//
//   @override
//   State<YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
// }
//
// class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
//   late YoutubePlayerController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     final videoId = YoutubePlayer.convertUrlToId(widget.url);
//     _controller = YoutubePlayerController(
//       initialVideoId: videoId ?? "",
//       flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _controller.mute();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return YoutubePlayer(
//       controller: _controller,
//       showVideoProgressIndicator: true,
//       progressIndicatorColor: AppColors.primary,
//     );
//   }
// }

class YoutubeVideoPlayer extends StatefulWidget {
  final String url;

  const YoutubeVideoPlayer({super.key, required this.url});

  @override
  State<YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
  YoutubePlayerController? _ytController;
  VideoPlayerController? _videoController;
  bool isYoutube = false;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.url);

    if (videoId != null) {
      isYoutube = true;
      _ytController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
      );
    } else {
      isYoutube = false;
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url))
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _ytController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isYoutube && _ytController != null) {
      return YoutubePlayer(
        controller: _ytController!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColors.primary,
      );
    } else if (_videoController != null &&
        _videoController!.value.isInitialized) {
      return SizedBox(
        height: 220,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController!.value.size.width,
                  height: _videoController!.value.size.height,
                  child: VideoPlayer(_videoController!),
                ),
              ),
            ),
            IconButton(
              iconSize: 50,
              color: Colors.white,
              icon: Icon(
                _videoController!.value.isPlaying
                    ? Icons.pause_circle
                    : Icons.play_circle,
              ),
              onPressed: () {
                setState(() {
                  if (_videoController!.value.isPlaying) {
                    _videoController!.pause();
                  } else {
                    _videoController!.play();
                  }
                });
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: VideoProgressIndicator(
                _videoController!,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: AppColors.primary,
                  bufferedColor: Colors.grey,
                  backgroundColor: Colors.black26,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
