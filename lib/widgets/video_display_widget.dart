import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreenWidget extends StatefulWidget {
  VideoScreenWidget({Key? key, required this.videoUrl}) : super(key: key);

  final String? videoUrl;

  @override
  _VideoScreenWidgetState createState() => _VideoScreenWidgetState();
}

class _VideoScreenWidgetState extends State<VideoScreenWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.videoUrl ?? "",
    );

    _controller.addListener(controllerListener);

    _controller.initialize();
  }

  void controllerListener() {
    if (_controller.value.isInitialized) {
      _controller.removeListener(controllerListener);
      playMyVideo();
    }
  }

  Future<void> playMyVideo() async {
    await _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(controllerListener);
    _controller.dispose();
    super.dispose();
  }
}
