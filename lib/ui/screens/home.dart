import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/config/constant.dart';

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

    children.add(
      Padding(
        padding: const EdgeInsets.only(bottom: SECTION_PADDING),
        child: _buildCategorySection(),
      )
    );

    MovieSection.values.forEach((section) {
      if (section != MovieSection.RECOMMENDATIONS && section != MovieSection.TRENDING) {
        children.add(Padding(
          padding: const EdgeInsets.only(bottom: SECTION_PADDING),
          child: _buildMovieSection(section),
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

  Widget _buildMovieSection(MovieSection section) {
    return SectionWidget(
      text: section.toText.toUpperCase(), sectionStyle: SectionStyle.HOME,
      list: ExpandableListView(
        stream: _bloc.movies(section),
        itemBuilder: (context, item){
          return _buildMovieCard(item);
        },
        onLoadMore: (nextPage, cache){
          _bloc.loadMovies(section, nextPage, cache);
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
      imgUrl = getFullImageUrl(movie.posterPath);
      
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
        onLoadMore: (nextPage, fromCache){
          _bloc.loadMovies(section, nextPage, fromCache);
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
      imgUrl = getFullImageUrl(movie.backdropPath);
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

  Widget _buildCategorySection() {
    return SectionWidget(
      text: "CATEGORY",
      sectionStyle: SectionStyle.TRENDING,
      list: ExpandableListView(
        stream: _bloc.genres,
        itemBuilder: (context, item){
          return _buildCategoryCard(item);
        },
        onLoadMore: (_, cache){
          _bloc.loadGenres(cache);
        },
        height: 80 * widthRatio,
        dummySize: 2,
      ),
      onPressed: () {

      },
    );
  }

  Widget _buildCategoryCard(Genre genre) {
    var cardSize = Size(140, 76) * widthRatio;
    var shadowRect = const Rect.fromLTWH(8, 12.7, 123, 67.3) * widthRatio;
    var genreTitle;
    if (genre != null && genre.name != null) {
      genreTitle = Container(
        alignment: Alignment.center,
        width: cardSize.width, height: cardSize.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            colors: [Color(0xFF00CBCF).withOpacity(0.5), Color(0xFF007AD9).withOpacity(0.5)]
          ),
          borderRadius: BorderRadius.circular(6)
        ),
        child: Text(
          genre.name,
          style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold
          ),
        ),
      );
    } else {
      genreTitle = Container();
    }
    return Padding(
      padding: TrendingCardConfig.PADDING,
      child: InkWell(
        child: BoxShadowImage(
          child: genreTitle,
          size: cardSize, borderRadius: 6,
          shadowRect: shadowRect,
          shadowBorderRadius: 5.3, shadowBlurRadius: 24,
        ),
        onTap: (){
          //TODO: goto category screen
        },
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