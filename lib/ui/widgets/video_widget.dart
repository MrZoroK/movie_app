import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/blocs.dart';
import 'package:movie_app/blocs/movie_detail_bloc.dart';
import 'package:movie_app/models.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

enum VideoState {
  NONE,
  LOADING,
  FAILED,
  READY,
  PLAYING,
  PAUSED
}
class ReadyPlayState with ChangeNotifier {
  VideoState _value = VideoState.NONE;
  VideoState get val => _value;
  set val(newVal){
    if (_value != newVal) {
      _value = newVal;
      notifyListeners();
    }
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
  VideoPlayerController _controller;
  MovieDetailBloc _bloc;

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = MyBlocProvider.of(context);
    }

    return ChangeNotifierProvider(
      create: (_) {
        var readyState = ReadyPlayState();
        readyState.val = VideoState.LOADING;
        _bloc.loadVideoUrl(widget.video.key, true).then((url){
          if (url != null && url !=  "")  {
            _controller = VideoPlayerController.network(url)
            ..initialize().then((_) {
              if (_controller.value.initialized) {
                readyState.val = VideoState.READY;
              } else {
                readyState.val = VideoState.FAILED;
              }
            });
            _controller.addListener(() {
              if (_controller.value.isPlaying) {
                readyState.val = VideoState.PLAYING;
              } else if (_controller.value.initialized) {
                readyState.val = VideoState.READY;
              }
            });
          }
        });
        return readyState;
      },
      child: Consumer<ReadyPlayState>(
        builder: (context, state, _){
          Widget videoPlayer;
          if (state.val == VideoState.LOADING) {
            videoPlayer = CircularProgressIndicator();
          } else if (state.val == VideoState.NONE) {
            videoPlayer = Container();
          } else if (state.val == VideoState.FAILED) {
            videoPlayer = Icon(
              Icons.warning, color: Colors.yellow, size: 50,
            );
          } else if (state.val.index >= VideoState.READY.index) {
            Widget overlayButton;
            if (state.val == VideoState.PLAYING) {
              overlayButton = Container();
            } else {
              overlayButton = Center(child: SvgPicture.asset("assets/ic-play-white.svg"));
            }
            videoPlayer = Stack(
              children: <Widget>[
                VideoPlayer(_controller),
                InkWell(
                  child: overlayButton,
                  onTap: () {
                    if (state.val == VideoState.PLAYING && _controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      if(_controller.value.position == _controller.value.duration) {
                        _controller.seekTo(Duration(seconds: 0, minutes: 0, hours: 0));
                        _controller.play();
                      } else {
                        _controller.play();
                      }
                    }
                  }
                )
              ]
            );
          }
          
          return Container(
            width: widget.size.width,
            child: ClipRRect(
              child: Center(child: videoPlayer),
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(12)
            )
          );
        },
      )
    );
  }
}