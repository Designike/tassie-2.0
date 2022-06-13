import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tassie/constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeFullScreen extends StatefulWidget {
  const YoutubeFullScreen({Key? key, required this.url})
      : super(key: key);
  final String url;

  @override
  State<YoutubeFullScreen> createState() => _YoutubeFullScreenState();
}

class _YoutubeFullScreenState extends State<YoutubeFullScreen> {
  late YoutubePlayerController nController;
  @override
  void deactivate() {
    super.deactivate();
    nController.pause();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    nController.dispose();
    super.dispose();
    
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nController = YoutubePlayerController(
              initialVideoId: widget.url,

              flags: const YoutubePlayerFlags(
                  mute: false, autoPlay: true, loop: false));
  }
  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        // SystemChrome.setPreferredOrientations(DeviceOrientation.values);
        // Navigator.of(context).pop();
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      },
      player: YoutubePlayer(
        controller: nController,
      ),
      builder: (context, player) => Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: player,
          ),
        ),
      ),
    );
  }
}
