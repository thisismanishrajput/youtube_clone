import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'package:video_player/video_player.dart';

import '../Common/Utils/colors.dart';
import '../Common/Widget/customeMaterial.dart';

class CommonVideoPlayerScreen extends StatefulWidget {
  final String? videoUrl;


  CommonVideoPlayerScreen({this.videoUrl});

  @override
  State<CommonVideoPlayerScreen> createState() =>
      _CommonVideoPlayerScreenState();
}

class _CommonVideoPlayerScreenState
    extends State<CommonVideoPlayerScreen> {

  VideoPlayerController? _resourceVideoPlayerController;
  ChewieController? _resourceVideoChewieController;
  String? m3u8Content;
  String fileTitle = "";

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    initializePlayer(widget.videoUrl!);
  }

  @override
  void dispose() {
    _resourceVideoPlayerController?.pause();
    _resourceVideoChewieController?.pause();
    _resourceVideoPlayerController?.dispose();
    _resourceVideoChewieController?.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    Wakelock.disable();
    super.dispose();
  }

  Future<void> initializePlayer(String videoUrl) async {
    print('videoUrl => $videoUrl');
    _resourceVideoPlayerController = VideoPlayerController.asset(
      videoUrl,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      // formatHint: VideoFormat.hls,
    );
    await _resourceVideoPlayerController!.initialize();
    _resourceVideoChewieController = ChewieController(
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitUp
      ],
      materialProgressColors: ChewieProgressColors(
        backgroundColor: const Color(0xffFFFFFF),
        handleColor: const Color.fromRGBO(200, 200, 200, 1.0),
        playedColor: const Color.fromRGBO(255, 0, 0, 0.7),
        bufferedColor: const Color.fromRGBO(30, 30, 200, 0.2),
      ),
      showControlsOnInitialize: false,
      customControls: CustomMaterialControls(),
      videoPlayerController: _resourceVideoPlayerController!,
      playbackSpeeds: [0.25, 0.5, 1.0, 1.5],
      autoPlay: true,
      looping: true,
      allowedScreenSleep: false,
      allowMuting: true,
    );
    if (mounted) {
      setState(() {
        print('1st SetState called');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height*0.3,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: _resourceVideoChewieController != null &&
                    _resourceVideoChewieController!
                        .videoPlayerController.value.isInitialized
                    ? _body()
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Loading'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Chewie(
            controller: _resourceVideoChewieController!,
          ),
        ),
      ],
    );
  }
}