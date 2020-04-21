import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/models/video.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ReadyPlayState with ChangeNotifier {
  bool _value = false;
  bool get val => _value;
  toggle() {
    _value = !_value;
    notifyListeners();
  }
}

class VideoWidget extends StatefulWidget {
  final Video video;
  final Size size;

  VideoWidget(this.video, this.size);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  YoutubePlayerController _controller; 

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
        initialVideoId: widget.video.key,
        flags: YoutubePlayerFlags(
            autoPlay: false,
            mute: true,
        ),
    );
    _controller.setSize(widget.size);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width,
      child: Stack(
        children: <Widget>[
          Center(
            child: ClipRRect(
              child: YoutubePlayer(
                width: widget.size.width,
                controller: _controller,
                showVideoProgressIndicator: true,
                progressColors: ProgressBarColors(
                    playedColor: Colors.amber,
                    handleColor: Colors.amberAccent,
                ),
                onReady: () {
                    _controller.addListener((){

                    });
                },
              ),
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(12)
            ),
          ),
        ],
      )
    );
  }
}