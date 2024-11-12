import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class TeacherScreen extends StatefulWidget {
  @override
  _TeacherScreenLiveState createState() => _TeacherScreenLiveState();
}

class _TeacherScreenLiveState extends State<TeacherScreen> {
  late VideoPlayerController _videoController;
  final TextEditingController _messageController = TextEditingController();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    _videoController = VideoPlayerController.asset('images/chapter1.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _messageController.dispose();
    super.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pushNamed('/listlecture');
          },
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                "Mrs Thanh",
                style: TextStyle(color: Colors.black),
              ),
            ),
            Icon(Icons.people, color: Colors.black),
            SizedBox(width: 5),
            Text(
              "30",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                _videoController.value.isInitialized
                    ? Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _videoController.value.size?.width ?? 0,
                            height: _videoController.value.size?.height ?? 0,
                            child: VideoPlayer(_videoController),
                          ),
                        ),
                      )
                    : Center(child: CircularProgressIndicator()),
                VideoProgressIndicator(
                  _videoController,
                  allowScrubbing: true,
                  padding: EdgeInsets.all(10),
                ),
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 50,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_isPlaying) {
                        _videoController.pause();
                      } else {
                        _videoController.play();
                      }
                      _isPlaying = !_isPlaying;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Nhập tin nhắn...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    print("Tin nhắn: ${_messageController.text}");
                    _messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
