import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/ui/screens/movie_detail_component/comment_item.dart';
import 'package:movie_app/ui/widgets/video_widget.dart';

import 'package:movie_app/uis.dart';
import 'package:movie_app/blocs.dart';
import 'package:movie_app/models.dart';
import 'package:movie_app/utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CastCardConfig {
  static const SIZE = const Size(70, 102);
  static const PADDING = const EdgeInsets.only(right: 15);
  static const SHADOW_RECT = const Rect.fromLTWH(7 , 23 , 57 , 83);
  static const TITLE_HEIGHT = 60;
}

class ReadMoreState with ChangeNotifier {
  bool _value = false;
  bool get val => _value;
  toggle() {
    _value = !_value;
    notifyListeners();
  }
}

class YourRateState with ChangeNotifier {
  double _value = 0.0;
  double get val => _value;
  set val(newVal){
    if (newVal >= 0 && newVal <= 5) {
      _value = newVal;
      notifyListeners();
    }
  }
}

class MovieDetailScreen extends StatefulWidget {
  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  MovieDetailBloc _bloc;

  static const BACKDROP_SIZE = Size(360, 220);
  static const POSTER_SIZE = Size(120, 180);
  static const POSTER_SHADOW_RECT = Rect.fromLTWH(7, 30, 105, 159);
  static const TOP_AREA_HEIGHT = 330.0;
  static const POSTER_POSTION = Point(16.0, 149.0);

  double _widthRatio;
  double get widthRatio{
    if (_widthRatio == null) {
      _widthRatio = MediaQuery.of(context).size.width / DESIGNED_WIDTH;
    }
    return _widthRatio;
  }

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = BlocProvider.of(context);
    }

    return Scaffold(
      body: SafeArea(
        top: true,
        child: ListView(
          children: <Widget>[
            Container(
              height: TOP_AREA_HEIGHT * widthRatio,
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  _buildbackdrop(),
                  _buildPosterAndRateInfo(),
                ],
              ),
            ),
            _buildTitle(),
            _buildOverview(),
            _buildFavoriteButton(),
            _buildRatingSection(),
            _buildCastSection(),
            _buildVideoSection(),
            _buildCommentsSection(),
            _buildRecommendationSection()
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: ALL_LEFT_PADDING.add(EdgeInsets.only(top: 15)),
      child: Text(
        _bloc.movie.title.toUpperCase(),
        style: TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: TITLE_COLOR
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    var commentButtonSize = Size(190, 34) * widthRatio;
    var starSize = Size(28.4, 27.3) * widthRatio;
    return ChangeNotifierProvider(
      create: (_) => YourRateState(),
      child: SectionWidget(
        text: "Your Rate",
        sectionStyle: SectionStyle.DETAIL,
        list: Consumer<YourRateState>(
          builder: (ctx, rateNum, child) {
            return Column(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index){
                    double rate = index.toDouble() + 1;
                    return Padding(
                      padding: const EdgeInsets.only(right: 9, left: 9),
                      child: InkWell(
                        child: SvgPicture.asset(
                          "assets/ic-star.svg",
                          width: starSize.width, height: starSize.height,
                          color: rate <= rateNum.val ? Color(0xFFF1CA23) : Color(0xFFD2D2D2)
                        ),
                        onTap: () => {
                          Provider.of<YourRateState>(ctx, listen: false).val = rate
                        },
                      ),
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 4),
                  child: Text(
                    rateNum.val.toStringAsPrecision(2),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF9B9B9B)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: FlatButton(
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: child,
                    onPressed: () => {
                      //TODO: write a comment
                    },
                  ),
                )
              ],
            );
          },
          child: Container(
            width: commentButtonSize.width, height: commentButtonSize.height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xFF007AD9),
              borderRadius: BorderRadius.circular(6)
            ),
            child: Text(
              "WRITE A COMMENT",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: FlatButton(
          padding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: 215, height: 50,
            decoration: BoxDecoration(
              color: Color(0xFFBACDE7),
              borderRadius: BorderRadius.circular(6)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SvgPicture.asset("assets/plus.svg", width: 18, height: 18),
                Text(
                  "Favorite",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
                ),
                SvgPicture.asset("assets/vertical-line.svg", width: 2, height: 20),
                SvgPicture.asset("assets/ic-triangle-down.svg", width: 12, height: 10),
              ],
            ),
          ),
          onPressed: () {
            //TODO: add favorite
          },
        ),
      ),
    );
  }

  Widget _buildOverview() {
    return ChangeNotifierProvider(
      create: (_) => ReadMoreState(),
      child: Column(
        children: <Widget>[
          Consumer<ReadMoreState>(
            builder: (context, readmore, child){
              return Container(
                height: readmore.val ? null: 140,
                padding: ALL_LEFT_PADDING,
                child: Text(
                  _bloc.movie.overview,
                  style: TextStyle(fontSize: 18, color: Color(0xFF4A4A4A)),
                  overflow: readmore.val ? null : TextOverflow.ellipsis,
                  maxLines: readmore.val ? null : 5
                ),
              );
            },
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(top: 7, right: 16),
            child:  Consumer<ReadMoreState>(
              builder: (ctx, readmore, child){
                return InkWell(
                  child: Text(
                    readmore.val ? "Read less" : "Read more",
                    style: TextStyle(
                      fontSize: 14, 
                      color: readmore.val ? const Color(0xFFF1CA23) : const Color(0xFF007AD9))
                  ),
                  onTap: () => {
                    Provider.of<ReadMoreState>(ctx, listen: false).toggle()
                  }
                );
              },
            ),
          )
        ],
      ),
    );
  }

  List<List<String>> _calcGenreTable(List<String> genres) {
    List<List<String>> table = List();
    List<String> row = List();
    int countCharacter = 0;
    for (int i = 0; i < genres.length; i++) {
      var genre = genres[i];
      if (countCharacter + genre.length <= 20) {
        row.add(genre);
        countCharacter += genre.length;
      } else {
        table.add(row);
        row = List()..add(genre);
        countCharacter = 0;
      }
      if (i == genres.length - 1) {
        table.add(row);
      }
    }
    return table;
  }
  Widget _buildGenresLayout(List<String> genres) {
    Widget genresLayout;
    if (genres == null) {
      var decor = BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8)
      );
      genresLayout = Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[50],
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 5),
              width: 35, height: 25,
              decoration: decor,
            ),
            Container(
              width: 50, height: 25,
              decoration: decor,
            )
          ],
        ),
      );
    } else {
      var tableOfGenreNames = _calcGenreTable(genres);
      genresLayout = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(tableOfGenreNames.length, (colIdx){
          var rows = tableOfGenreNames[colIdx];
          return Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Row(
              children: List.generate(rows.length, (rowIdx){
                var genre = rows[rowIdx];
                return Container(
                  padding: EdgeInsets.only(left: 11, right: 11, top: 2, bottom: 5),
                  margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    color: Color(0xFF007AD9),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Text(
                    genre,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                );
              })
            ),
          );
        })
      );
    }
    return Container(
        margin: EdgeInsets.only(top: 9),
        child: genresLayout
    );
  }
  Widget _buildRateAndGenres() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        VoteStar(rating: _bloc.movie.voteRate, size: 15, starAlign: 7),
        Text(
          _bloc.movie.formatedReleaseDate,
          style: TextStyle(
            fontSize: 14, color: TITLE_COLOR
          ),
        ),
        StreamProvider<List<String>>(
          create: (_){
            _bloc.loadGenres();
            return _bloc.genres;
          },
          child: Consumer<List<String>>(
            builder: (context, genres, _){
              return _buildGenresLayout(genres);
            },
          ),
        )
      ],
    );
  }

  Widget _buildPosterAndRateInfo() {
    var posterSize = POSTER_SIZE * widthRatio;
    var posterPos = POSTER_POSTION * widthRatio;
    var backdropSize = BACKDROP_SIZE * widthRatio;
    return Positioned(
      left: posterPos.x, top: posterPos.y,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: posterSize.height + 50,
            child: BoxShadowImage(
              imgUrl: "https://image.tmdb.org/t/p/original${_bloc.movie.posterPath}",
              size: posterSize, borderRadius: 6,
              shadowRect: POSTER_SHADOW_RECT * widthRatio,
              shadowBorderRadius: 6, shadowBlurRadius: 24,
            ),
          ),
          Container(
            child: _buildRateAndGenres(),
            padding: EdgeInsets.only(top: backdropSize.height - posterPos.y + 6, left: 10)
          )
        ],
      )
    );
  }

  double get _castSecionHeight {
    Size cardSize = CastCardConfig.SIZE * widthRatio;
    return cardSize.height + CastCardConfig.TITLE_HEIGHT;
  }
  Widget _buildCastSection() {
    return SectionWidget(
      text: "Series Cast", sectionStyle: SectionStyle.DETAIL,
      list: ExpandableListView(
        stream: _bloc.casts,
        itemBuilder: (context, item){
          return _buildCastCard(item);
        },
        onLoadMore: (_){
          //to refresh
          _bloc.loadCasts();
        },
        dummySize: 4,
        height: _castSecionHeight,
      ),
    );
  }

  Widget _buildCastCard(Cast cast) {
    String imgUrl;
    Widget title = Container();
    Size castSize = CastCardConfig.SIZE * widthRatio;
    Widget child;
    if (cast != null) {
      if (cast.profilePath != null) {
        imgUrl = "https://image.tmdb.org/t/p/original${cast.profilePath}";
      } else {
        child = Icon(
          Icons.person, size: castSize.width / 2,
        );
      }
      
      title = Container(
        width: castSize.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(height: castSize.height),
            Container(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                cast.name, 
                style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF4A4A4A), fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              child: Text(
                cast.character, 
                style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xFF9B9B9B), fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }
    
    return Padding(
      padding: CastCardConfig.PADDING * widthRatio,
      child: Stack(
        children: <Widget>[
          Container(
            height: _castSecionHeight,
            child: BoxShadowImage(
              imgUrl: imgUrl, size: castSize, borderRadius: 3,
              child: child,
              shadowRect: CastCardConfig.SHADOW_RECT * widthRatio,
              shadowBorderRadius: 4.8, shadowBlurRadius: 24.5,
            ),
          ),
          title
        ],
      ),
    );
  }

  Widget _buildVideoSection() {
    return SectionWidget(
      text: "Video", sectionStyle: SectionStyle.DETAIL,
      list: ExpandableListView(
        stream: _bloc.videos,
        itemBuilder: (context, item){
          return _buildVideoCard(item);
        },
        onLoadMore: (_){
          //to refresh
          _bloc.loadVideos();
        },
        height: 180,
      ),
    );
  }

  Widget _buildVideoCard(Video video) {
    Size videoSize = Size(200, 200 * 9 / 16) * widthRatio;
    Rect shadowRect = Rect.fromLTWH(10 , 10 , 180 , 120);
    return Padding(
      padding: const EdgeInsets.only(right: 20) * widthRatio,
      child: Container(
        child: BoxShadowImage(
          size: videoSize, borderRadius: 12,
          shadowRect: shadowRect * widthRatio,
          shadowBorderRadius: 12, shadowBlurRadius: 24.5,
          child: video == null ? Container() : VideoWidget(video, videoSize),
        ),
      )
    );
  }

  Widget _buildCommentsSection() {
    return SectionWidget(
      text: "Comments", sectionStyle: SectionStyle.DETAIL,
      onPressed: () {
        //Todo: Comment section arrow
      },
      list: ExpandableListView(
        stream: _bloc.reviews,
        itemBuilder: (context, item){
          return CommentItem(item);
        },
        verticalItemHeight: 140,
        scrollDirection: Axis.vertical,
        pullToRefresh: false,
        onLoadMore: (page) => _bloc.loadReviews(page),
        dummySize: 1,
        height: 450
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
    return SectionWidget(
      text: "Recommendations", sectionStyle: SectionStyle.DETAIL,
      onPressed: () {
        //TODO: Recommendations arrow
      },
      list: ExpandableListView(
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
        dummySize: 3,
        height: 230,
      ),
    );
  }

  Widget _buildRecommendationCard(MovieBase movie) {
    String imgUrl;
    Widget title = Container();
    Size size = Size(100, 150) * widthRatio;
    double radius = 6.0;
    if (movie != null) {
      imgUrl = "https://image.tmdb.org/t/p/original${movie.posterPath}";
      
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
              style: TextStyle(fontWeight: FontWeight.bold, color: TITLE_COLOR,fontSize: 12),
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
              imgUrl: imgUrl, size: size, borderRadius: radius,
              shadowRect: Rect.fromLTWH(6 * widthRatio, 25 * widthRatio, 88 * widthRatio, 132 * widthRatio),
              shadowBorderRadius: 5.3, shadowBlurRadius: 24,
            ),
          ),
          title
        ],
      ),
    );
  }

  Widget _buildbackdrop() {
    Size backdropSize = BACKDROP_SIZE * widthRatio;
    return Container(
      width: backdropSize.width, height: backdropSize.height,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
            color: Colors.grey[300],
            child: CommonWidgetBuilder.loadNetworkImage(
              "https://image.tmdb.org/t/p/original${_bloc.movie.backdropPath}",
              width: backdropSize.width, height: backdropSize.height,
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
          Container(
            margin: EdgeInsets.only(left: 16, top: 30),
            child: InkWell(
              child: SvgPicture.asset(
                "assets/ic-back.svg",
                width: 20, height: 20
              ),
              onTap: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }
}