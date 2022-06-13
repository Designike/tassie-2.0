import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeFullScreen extends StatelessWidget {
  const YoutubeFullScreen({Key? key, required this.yController})
      : super(key: key);
  final YoutubePlayerController yController;

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      // onExitFullScreen: () {
      //   Navigator.of(context).pop();
      // },
      player: YoutubePlayer(
        controller: yController,
      ),
      builder: (context, player) => Scaffold(
        body: Container(
          child: player,
        ),
      ),
    );
  }
}
