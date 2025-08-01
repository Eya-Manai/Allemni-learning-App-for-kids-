import 'package:allemni/constants/colors.dart';
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
      if (!mounted) return;
      setState(() {});
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

  String formattedDuration(Duration position) {
    String twodigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twodigits(position.inMinutes.remainder(60));
    final seconds = twodigits(position.inSeconds.remainder(60));

    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("مشاهدة الفيديو", textDirection: TextDirection.rtl),
      ),
      body: isInitilized
          ? Stack(
              children: [
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: controller.value.size.width,
                      height: controller.value.size.height,
                      child: VideoPlayer(controller),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      VideoProgressIndicator(
                        controller,
                        allowScrubbing: true,
                        colors: VideoProgressColors(
                          playedColor: AppColors.primaryYellow,
                          bufferedColor: AppColors.white,
                          backgroundColor: AppColors.lightblack,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formattedDuration(controller.value.position),
                            style: TextStyle(color: AppColors.white),
                          ),
                          Text(
                            formattedDuration(controller.value.duration),
                            style: TextStyle(color: AppColors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator(color: Colors.white)),
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
