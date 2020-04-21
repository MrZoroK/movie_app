import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:movie_app/config/movie_section.dart';
import 'package:movie_app/blocs.dart';
import 'package:movie_app/models.dart';
import 'package:movie_app/uis.dart';
import 'package:movie_app/utils.dart';

class MovieCardConfig {
  static const SIZE = const Size(140, 210);
  static const PADDING = const EdgeInsets.only(right: 20);
  static const SHADOW_RECT = const Rect.fromLTWH(8, 35, 123, 185);
  static const TITLE_HEIGHT = 60;
}
class TrendingCardConfig {
  static const SIZE = const Size(300, 160);
  static const PADDING = const EdgeInsets.only(right: 20);
  static const SHADOW_RECT = const Rect.fromLTWH(15, 26, 275, 144);
  static const TITLE_HEIGHT = 50;
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc _bloc;
  static const SECTION_PADDING = 20.0;

  double _widthRatio;
  double get widthRatio{
    if (_widthRatio == null) {
      _widthRatio = MediaQuery.of(context).size.width / DESIGNED_WIDTH;
    }
    return _widthRatio;
  } 

  _gotoMovieDetailScreen(MovieBase moviebase) {
    Navigator.push(
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
  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = BlocProvider.of(context);
    }
    
    return Scaffold(
      appBar: _topbar(context),
      body: _buildSections(),
    );
  }

  Widget _buildSections() {
    List<Widget> children = List();
    children.add(Padding(
      padding: const EdgeInsets.only(top: SECTION_PADDING),
      child: _buildTrending(),
    ));

    MovieSection.values.forEach((section) {
      if (section != MovieSection.RECOMMENDATIONS && section != MovieSection.TRENDING) {
        children.add(Padding(
          padding: const EdgeInsets.only(bottom: SECTION_PADDING),
          child: _buildSection(section),
        ));
      }
    });
    
    return Center(
      child: ListView(
        children: children,
      ),
    );
  }

  double get _movieSecionHeight {
    Size cardSize = MovieCardConfig.SIZE * widthRatio;
    return cardSize.height + MovieCardConfig.TITLE_HEIGHT;
  }

  Widget _buildSection(MovieSection section) {
    return SectionWidget(
      text: section.toText.toUpperCase(), sectionStyle: SectionStyle.HOME,
      list: ExpandableListView(
        stream: _bloc.movies(section),
        itemBuilder: (context, item){
          return _buildMovieCard(item);
        },
        onLoadMore: (nextPage){
          _bloc.loadMovies(section, nextPage);
        },
        height: _movieSecionHeight,
      ),
      onPressed: () {

      },
    );
  }

  Widget _buildMovieCard(MovieBase movie) {
    String imgUrl;
    Widget title = Container();

    Size cardSize = MovieCardConfig.SIZE * widthRatio;
    Rect cardShadowRect = MovieCardConfig.SHADOW_RECT * widthRatio;

    if (movie != null) {
      imgUrl = "https://image.tmdb.org/t/p/original${movie.posterPath}";
      
      title = Column(
        children: <Widget>[
          Container(height: cardSize.height, margin: EdgeInsets.only(bottom: 10)),
          Container(
            width: cardSize.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: cardSize.width - 7,
                  child: Text(
                    movie.title, 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15, color: TITLE_COLOR,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                InkWell(
                  child: SvgPicture.asset("assets/ic-moredetails.svg"),
                  onTap: () => _gotoMovieDetailScreen(movie),
                )
              ],
            ),
          )
        ],
      );
    }
    

    return Padding(
      padding: MovieCardConfig.PADDING,
      child: Stack(
        children: <Widget>[
          Container(
            height: _movieSecionHeight,
            child: InkWell(
              child: BoxShadowImage(
                imgUrl: imgUrl,
                size: cardSize, borderRadius: 6,
                shadowRect: cardShadowRect,
                shadowBorderRadius: 5.3, shadowBlurRadius: 24,
              ),
              onTap: () => _gotoMovieDetailScreen(movie),
            ),
          ),
          title
        ],
      ),
    );
  }

  double get _trendingSecionHeight {
    Size cardSize = TrendingCardConfig.SIZE * widthRatio;
    return cardSize.height + TrendingCardConfig.TITLE_HEIGHT;
  }
  Widget _buildTrending() {
    var section = MovieSection.TRENDING;
    return SectionWidget(
      text: section.toText.toUpperCase(),
      sectionStyle: SectionStyle.TRENDING,
      list: ExpandableListView(
        stream: _bloc.movies(section),
        itemBuilder: (context, item){
          return _buildTrendingMovieCard(item);
        },
        onLoadMore: (nextPage){
          _bloc.loadMovies(section, nextPage);
        },
        height: _trendingSecionHeight,
        dummySize: 2,
      ),
      onPressed: () {

      },
    );
  }

  Widget _buildTrendingMovieCard(MovieBase movie) {
    String imgUrl;
    Size cardSize = TrendingCardConfig.SIZE * widthRatio;
    if (movie != null) {
      imgUrl = "https://image.tmdb.org/t/p/original${movie.backdropPath}";
    }

    return Padding(
      padding: TrendingCardConfig.PADDING,
      child: InkWell(
        child: BoxShadowImage(
          imgUrl: imgUrl,
          size: cardSize, borderRadius: 6,
          shadowRect: TrendingCardConfig.SHADOW_RECT * widthRatio,
          shadowBorderRadius: 5.4, shadowBlurRadius: 24.5,
        ),
        onTap: () => _gotoMovieDetailScreen(movie),
      ),
    );
  }

  

  Widget _topbar(BuildContext context) {
    var appBar = AppBar(
      leading: FlatButton(
        child: SvgPicture.asset("assets/ic-user.svg"),
        onPressed: (){
          // TODO: login
        },
      ),
      backgroundColor: Colors.white,
      title: Container(
        alignment: Alignment.center,
        child: Image(
          image: AssetImage("assets/logo.png"),
        ),
      ),
      actions: [
        SvgPicture.asset("assets/ic-search.svg"),
      ],
    );
    return appBar;    
  }
}