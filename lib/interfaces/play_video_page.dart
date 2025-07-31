import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayVideoPage extends StatefulWidget {
  final String vedioPath;
  const PlayVideoPage({super.key, required this.vedioPath});
  @override
  State<PlayVideoPage> createState() => _PlayVedioPage();
}

class _PlayVedioPage extends State<PlayVideoPage> {
  late VideoPlayerController controller;
  bool isInitilized = false;

  @override
  void initState() {
    super.initState();
    if (widget.vedioPath.startsWith("http")) {
      controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.vedioPath),
      );
    } else {
      controller = VideoPlayerController.asset(widget.vedioPath);
    }

    controller.addListener(() {
      if (controller.value.hasError) {
        debugPrint("video path error ${controller.value.errorDescription}");
      }
    });

    controller.initialize().then((_) {
      setState(() {
        isInitilized = true;
      });
      controller.play();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("مشاهدة الفيديو"),
      ),
      body: Center(
        child: isInitilized
            ? AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              )
            : const CircularProgressIndicator(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(
          controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.black,
        ),
        onPressed: () {
          setState(() {
            controller.value.isPlaying ? controller.pause() : controller.play();
          });
        },
      ),
    );
  }
}
