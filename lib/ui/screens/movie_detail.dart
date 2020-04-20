import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/blocs/movie_detail_bloc.dart';
import 'package:movie_app/config/movie_section.dart';
import 'package:movie_app/models/movie_base.dart';
import 'package:movie_app/ui/widgets/box_shadow_image.dart';
import 'package:movie_app/ui/widgets/common_widget_builder.dart';
import 'package:movie_app/ui/widgets/expandable_listview.dart';
import 'package:movie_app/ui/widgets/section_widget.dart';
import 'package:movie_app/ui/widgets/vote_star.dart';
import 'dart:ui' as ui;

import '../../blocs.dart';
import '../../models.dart';

enum MonthName {
  January,
  February,
  March,
  April,
  May,
  June,
  July,
  August,
  September,
  October,
  November,
  December
}
extension DateTimeEx on DateTime {
  String get monthAndYear {
    String strMonth = "";
    MonthName.values.forEach((element) {
      if (element.index + 1 == month) {
        strMonth = element.toString().replaceAll("MonthName.", "");
      }
    });
    return strMonth + " $year";
  }
}

class MovieDetailScreen extends StatefulWidget {
  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  MovieDetailBloc _bloc;

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = BlocProvider.of(context);
      //_bloc.loadCasts(widget.movieBase.id);
    }

    //TODO: remove this
    _bloc.loadCasts();
    _bloc.loadRecommendedMovies(1);

    var width = MediaQuery.of(context).size.width;
    var height = width * 220.0 / 360.0;

    Size posterSize = Size(120, 180);
    return Scaffold(
      body: SafeArea(
        top: true,
        child: ListView(
          children: <Widget>[
            Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                _buildbackdrop(),
                Positioned(
                  left: 16, top: 149 / 220.0 * height,
                  child: Container(
                    height: posterSize.height + 50,
                    child: BoxShadowImage(
                      child: CommonWidgetBuilder.loadNetworkImage(
                        "https://image.tmdb.org/t/p/original${_bloc.movie.posterPath}",//TODO: remove hardcode url
                        width: posterSize.width, height: posterSize.height, roundRadius: 6.0,
                        linearProcess: false
                      ),
                      size: posterSize, bgColor: Colors.grey[300],
                        borderRadius: 6,
                      shadowBox: Rect.fromLTWH(7, 30, 105, 159),
                      shadowColor: Color(0xFF4A4A4A).withOpacity(0.7),
                      shadowRadius: 6, shadowBlurRadius: 24,
                    ),
                  )
                ),
                Positioned(
                  left: 146, top: 226 / 220.0 * height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              _bloc.movie.voteRate.toStringAsPrecision(2),
                              style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFFF1CA23),
                                fontFamily: "Open Sans"
                              )
                            ),
                          ),
                          VoteStar(rating: _bloc.movie.voteRate, size: 15, starAlign: 7),
                        ],
                      ),
                      Text(
                        _bloc.movie.releaseDate.monthAndYear,
                        style: TextStyle(
                          fontFamily: "Helvetica", fontSize: 14, color: Color(0xFF3E4A59)
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: (posterSize.height + 50) / 2, left: 16),
              child: Text(
                _bloc.movie.title.toUpperCase(),
                style: TextStyle(
                  fontFamily: "Open Sans", fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF3E4A59)
                ),
              ),
            ),
            Container(
              height: 140,
              padding: EdgeInsets.only(left: 16),
              child: Text(
                _bloc.movie.overview,
                style: TextStyle(
                  fontFamily: "Helvetica", fontSize: 18, color: Color(0xFF4A4A4A),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 5
              ),
            ),
            _buildCastSection(),
            _buildRecommendationSection()
          ],
        ),
      ),
      backgroundColor: Color(0xFFF8F8F8),
    );
  }

  Widget _buildCastSection() {
    return SectionWidget(
      text: "Series Cast", sectionStyle: SectionStyle.DETAIL,
      list: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: ExpandableListView(
          stream: _bloc.casts,
          itemBuilder: (context, item){
            return _buildCastCard(item);
          },
          onLoadMore: (_){
            //to refresh
            _bloc.loadCasts();
          },
          height: 165,
        ),
      ),
    );
  }

  Widget _buildCastCard(Cast cast) {
    Widget img = Container();
    Widget title = Container();
    var widthRatio = MediaQuery.of(context).size.width / 360;
    Size size = Size(70, 102) * widthRatio;
    if (cast != null) {
      img = CommonWidgetBuilder.loadNetworkImage(        
        "https://image.tmdb.org/t/p/original${cast.profilePath}", roundRadius: 3.0, linearProcess: false,
        width: size.width, height: size.height,
      );
      
      title = Container(
        alignment: Alignment.bottomCenter,
        width: size.width, height: size.height + 37,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              child: Text(
                cast.name, 
                style: TextStyle(
                  fontFamily: 'Open Sans', fontWeight: FontWeight.w500, color: Color(0xFF4A4A4A),
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              child: Text(
                cast.character, 
                style: TextStyle(
                  fontFamily: 'Helvetica', fontWeight: FontWeight.w300, color: Color(0xFF9B9B9B),
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }
    
    return Padding(
      padding: EdgeInsets.only(right: 15 * widthRatio),
      child: Stack(
        children: <Widget>[
          Container(
            height: 164,
            child: BoxShadowImage(
              child: img, size: size, bgColor: Colors.grey[300], borderRadius: 3,
              shadowBox: Rect.fromLTWH(7 * widthRatio, 23 * widthRatio, 57 * widthRatio, 83 * widthRatio),
              shadowColor: Color(0xFF4A4A4A).withOpacity(0.7),
              shadowRadius: 4.8, shadowBlurRadius: 24.5,
            ),
          ),
          title
        ],
      ),
    );
  }

  _gotoMovieDetailScreen(MovieBase moviebase) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<MovieDetailBloc>(
          builder: (_, bloc) {
            return bloc ?? MovieDetailBloc(moviebase);
          },
          child: MovieDetailScreen(),
        )
      )
    );
  }

  Widget _buildRecommendationSection() {
    var widthRatio = MediaQuery.of(context).size.width / 360;
    return SectionWidget(
      text: "Recommendations", sectionStyle: SectionStyle.DETAIL,
      list: Padding(
        padding: EdgeInsets.only(left: 16.0 * widthRatio, bottom: 80),
        child: ExpandableListView(
          stream: _bloc.recommendation,
          itemBuilder: (context, item){
            return InkWell(
              child: _buildRecommendationCard(item),
              onTap: () => _gotoMovieDetailScreen(item),
            );
          },
          onLoadMore: (nextPage){
            _bloc.loadRecommendedMovies(nextPage);
          },
          height: 230,
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(MovieBase movie) {
    Widget img = Container();
    Widget title = Container();
    var widthRatio = MediaQuery.of(context).size.width / 360;
    Size size = Size(100, 150) * widthRatio;
    double radius = 6.0;
    if (movie != null) {
      img = CommonWidgetBuilder.loadNetworkImage(        
        "https://image.tmdb.org/t/p/original${movie.posterPath}", roundRadius: radius, linearProcess: false,
        width: size.width, height: size.height,
      );
      
      title = Container(
        alignment: Alignment.bottomCenter,
        width: size.width,
        child: Column(
          children: <Widget>[
            Container(
              height: size.height,
              margin: EdgeInsets.only(bottom: 7.3),
            ),
            Text(
              movie.title, 
              style: TextStyle(
                fontFamily: 'Open Sans', fontWeight: FontWeight.bold, color: Color(0xFF3E4A59),
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      );
    }
    
    return Padding(
      padding: EdgeInsets.only(right: 14 * widthRatio),
      child: Stack(
        children: <Widget>[
          Container(
            height: 230,
            child: BoxShadowImage(
              child: img, size: size, bgColor: Colors.grey[300], borderRadius: radius,
              shadowBox: Rect.fromLTWH(6 * widthRatio, 25 * widthRatio, 88 * widthRatio, 132 * widthRatio),
              shadowColor: Color(0xFF4A4A4A).withOpacity(0.7),
              shadowRadius: 5.3, shadowBlurRadius: 24,
            ),
          ),
          title
        ],
      ),
    );
  }

  Widget _buildbackdrop() {
    var width = MediaQuery.of(context).size.width;
    var height = width * 220.0 / 360.0;
    return Container(
      width: width, height: height,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
            color: Colors.grey[300],
            child: CommonWidgetBuilder.loadNetworkImage(
              "https://image.tmdb.org/t/p/original${_bloc.movie.backdropPath}",
              width: width, height: height,
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
            child: InkWell(
              child: SvgPicture.asset(
                "assets/ic-back.svg",
                width: 18, height: 18
              ),
              onTap: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }
}