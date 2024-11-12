import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;

  VideoPlayerPage({required this.videoUrl});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _youtubePlayerController;

  @override
  void initState() {
    super.initState();
    // Lấy videoId từ URL của YouTube
    String videoId = YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '';
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: false,
      ),
    );
  }

  @override
  void dispose() {
    _youtubePlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      // Bọc Column trong SingleChildScrollView để tránh overflow
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Sử dụng Expanded để video player chiếm không gian còn lại
            Expanded(
              child: YoutubePlayer(
                controller: _youtubePlayerController,
                showVideoProgressIndicator: true,
                onReady: () {
                  print('Player is ready.');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
