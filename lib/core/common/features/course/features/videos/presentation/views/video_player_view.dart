import 'package:chewie/chewie.dart';
import 'package:education_app/core/common/widgets/nested_back_button.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({
  required this.videoUrl
  ,super.key,});
  final String videoUrl;
  static const route = '/video-player';

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {

  late VideoPlayerController videoPlayerController;
  bool loop = false;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer()async{

    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),);
    await videoPlayerController.initialize();
    _createChewieController();
    setState(() {});

  }

  void _createChewieController(){
    chewieController = ChewieController(
        autoPlay: true,
        hideControlsTimer: const Duration(seconds: 5,)
        ,videoPlayerController: videoPlayerController,);
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const NestedBackButton(),
        backgroundColor: Colors.transparent,
      ),
      body:
      chewieController != null &&
      chewieController!.videoPlayerController.value.isInitialized
       ?
          Chewie(controller: chewieController!,):
          const Center(child: CircularProgressIndicator(),),

    );
  }
}
