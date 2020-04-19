import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/models/movie_base.dart';
import 'package:movie_app/ui/widgets/common_widget_builder.dart';

class MovieDetailScreen extends StatefulWidget {
  final MovieBase movieBase;

  MovieDetailScreen({@required this.movieBase});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
              child: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                _buildbackdrop()
              ],
            )
          ],
        ),
      ),
      backgroundColor: Color(0xFFF2F2F2),
    );
  }

  Widget _buildbackdrop() {
    var appBarW = MediaQuery.of(context).size.width;
    var appBarH = appBarW * 220.0 / 360.0;
    return Stack(
      children: <Widget>[
        Container(
          width: appBarW, height: appBarH,
          color: Colors.grey[300],
          child: CommonWidgetBuilder.loadNetworkImage(
            "https://image.tmdb.org/t/p/original${widget.movieBase.backdropPath}",
            width: appBarW, height: appBarH,
            linearProcess: false
          ),
        ),
        Center(
          child: InkWell(
            child: Image.asset(
              "assets/ic-play-blue.png",
              width: 55, height: 55
            ),
            onTap: () {
              //TODO: play movies trailer
            },
          ),
        ),
        Positioned(
          top: 37, left: 16,
          child: SvgPicture.asset(
            "assets/ic-back.svg",
            width: 18, height: 18
          ),
        )
      ],
    );
  }
}