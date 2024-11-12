import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:videosdk/videosdk.dart';

class TeacherScreenLive extends StatefulWidget {
  final List<CameraDescription> cameras;

  const TeacherScreenLive({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<TeacherScreenLive> {
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;
  Room? _room;
  bool _isLivestreaming = false;
  bool _isMounted = true;

  final String _displayName = 'Trần Đức Vũ';
  final String _roomId = '5ro3-jhtj-9y4l';
  final String _token = 'ddb2cfd5-4804-4266-9a1a-6b6e58ca49bf';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _requestPermissions() async {
    if (!_isMounted) return;
    if (Theme.of(context).platform == TargetPlatform.android ||
        Theme.of(context).platform == TargetPlatform.iOS) {
      try {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.camera,
          Permission.microphone,
        ].request();

        if (!_isMounted) return;

        if (statuses[Permission.camera]!.isGranted &&
            statuses[Permission.microphone]!.isGranted) {
          await _initializeCamera();
          await _initializeVideoSDK();
        } else {
          _showSnackBar(
              'Cần cấp quyền camera và microphone để sử dụng tính năng này');
        }
      } catch (e) {
        if (_isMounted) {
          _showSnackBar('Lỗi khi yêu cầu quyền: $e');
        }
      }
    } else {
      await _initializeCamera();
      await _initializeVideoSDK();
    }
  }

  void _showSnackBar(String message) {
    if (!_isMounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _initializeCamera() async {
    if (!_isMounted) return;

    try {
      _controller = CameraController(
        widget.cameras[0],
        ResolutionPreset.high,
        enableAudio: true,
      );
      if (_isMounted) {
        setState(() {
          _initializeControllerFuture = _controller.initialize();
        });
      }
    } catch (e) {
      print("Lỗi khởi tạo camera: $e");
      if (_isMounted) {
        _showSnackBar('Không thể khởi tạo camera: $e');
      }
    }
  }

  Future<void> _initializeVideoSDK() async {
    if (!_isMounted) return;

    try {
      _room = await VideoSDK.createRoom(
        roomId: _roomId,
        displayName: _displayName,
        token: _token,
      );
    } catch (e) {
      print("Lỗi khởi tạo VideoSDK: $e");
      if (_isMounted) {
        _showSnackBar('Không thể khởi tạo VideoSDK: $e');
      }
    }
  }

  Future<void> _toggleLivestream() async {
    if (!_isMounted) return;

    if (!_isLivestreaming) {
      try {
        await _requestPermissions();

        await _initializeControllerFuture;
        await _room?.join();
        await _room?.startRecording();

        setState(() => _isLivestreaming = true);
        _showSnackBar('Đã bắt đầu livestream');
      } catch (e) {
        print("Lỗi livestream: $e");
        if (_isMounted) {
          _showSnackBar('Không thể bắt đầu livestream: $e');
        }
      }
    } else {
      try {
        await _room?.stopRecording();
        _room?.leave();

        if (!_isMounted) return;

        setState(() => _isLivestreaming = false);
        _showSnackBar('Đã dừng livestream');
      } catch (e) {
        print("Lỗi khi dừng livestream: $e");
      }
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    _controller.dispose();
    _room?.leave();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livestream'),
      ),
      body: _initializeControllerFuture == null
          ? const Center(child: Text('Nhấn để bắt đầu livestream'))
          : FutureBuilder(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: [
                      CameraPreview(_controller),
                      if (_isLivestreaming)
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.circle,
                                    color: Colors.white, size: 12),
                                SizedBox(width: 4),
                                Text(
                                  'LIVE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleLivestream,
        backgroundColor: _isLivestreaming ? Colors.red : Colors.blue,
        child: Icon(_isLivestreaming ? Icons.stop : Icons.live_tv),
      ),
    );
  }
}
