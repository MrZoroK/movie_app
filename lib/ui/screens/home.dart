import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/blocs/home_bloc.dart';
import 'package:movie_app/config/movie_section.dart';
import 'package:movie_app/models.dart';
import 'package:movie_app/models/movie_base.dart';
import 'package:movie_app/ui/screens/movie_detail.dart';
import 'package:movie_app/ui/widgets/box_shadow_image.dart';
import 'package:movie_app/ui/widgets/common_widget_builder.dart';
import 'package:movie_app/ui/widgets/expandable_listview.dart';
import 'package:movie_app/ui/widgets/section_widget.dart';

import '../../blocs.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc _bloc;

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
      //_bloc.loadTrendingMovies(1);
    }

    //TODO: remove this
    MovieSection.values.forEach((e) {
      if (e != MovieSection.RECOMMENDATIONS) {
        _bloc.loadMovies(e, 1);
      }
    });
    
    return Scaffold(
      appBar: _topbar(context),
      body: _buildSections(),
      backgroundColor: Color(0xFFF8F8F8),
    );
  }

  Widget _buildSections() {
    List<Widget> children = List();
    children.add(Container());
    children.add(Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: _buildTrending(),
    ));

    MovieSection.values.forEach((section) {
      if (section != MovieSection.RECOMMENDATIONS && section != MovieSection.TRENDING) {
        children.add(Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: _buildSection(section),
        ));
      }
    });
    children.add(Container());
    
    return Center(
      child: ListView(
        children: children,
      ),
    );
  }

  Widget _buildSection(MovieSection section) {
    return SectionWidget(
      text: section.toText.toUpperCase(), sectionStyle: SectionStyle.HOME,
      list: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: ExpandableListView(
          stream: _bloc.movies(section),
          itemBuilder: (context, item){
            return _buildMovieCard(item);
          },
          onLoadMore: (nextPage){
            _bloc.loadMovies(section, nextPage);
          },
          height: 260,
        ),
      ),
      onPressed: () {

      },
    );
  }

  Widget _buildMovieCard(MovieBase movie) {
    Widget img = Container();
    Widget title = Container();
    Size size = Size(140, 210);
    if (movie != null) {
      img = CommonWidgetBuilder.loadNetworkImage(        
        "https://image.tmdb.org/t/p/original${movie.posterPath}", roundRadius: 6.0, linearProcess: false,
        width: size.width, height: size.height,
      );
      
      title = Container(
        alignment: Alignment.bottomCenter,
        width: size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: size.width - 5, height: 40,
              child: Text(
                movie.title, 
                style: TextStyle(
                  fontFamily: 'Open Sans', fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
              ),
            ),
            InkWell(
              child: SvgPicture.asset("assets/ic-moredetails.svg"),
              onTap: () => _gotoMovieDetailScreen(movie),
            )
          ],
        ),
      );
    }
    

    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Stack(
        children: <Widget>[
          Container(
            height: 260,
            child: InkWell(
              child: BoxShadowImage(
                child: img, size: size, bgColor: Colors.grey[300], borderRadius: 6,
                shadowBox: Rect.fromLTWH(8, 35, 123, 185),
                shadowColor: Color(0xFF4A4A4A).withOpacity(0.7),
                shadowRadius: 5.3, shadowBlurRadius: 24,
              ),
              onTap: () => _gotoMovieDetailScreen(movie),
            ),
          ),
          title
        ],
      ),
    );
  }

  Widget _buildTrending() {
    var section = MovieSection.TRENDING;
    return SectionWidget(
      text: section.toText.toUpperCase(),
      sectionStyle: SectionStyle.TRENDING,
      list: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: ExpandableListView(
          stream: _bloc.movies(section),
          itemBuilder: (context, item){
            return _buildTrendingMovieCard(item);
          },
          onLoadMore: (nextPage){
            _bloc.loadMovies(section, nextPage);
          },
          height: 210,
          dummySize: 2,
        ),
      ),
      onPressed: () {

      },
    );
  }

  Widget _buildTrendingMovieCard(MovieBase movie) {
    Widget img;
    Size size = Size(300, 160);
    if (movie != null) {
      img = CommonWidgetBuilder.loadNetworkImage(        
        "https://image.tmdb.org/t/p/original${movie.backdropPath}", roundRadius: 6.0, linearProcess: false,
        width: size.width, height: size.height,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: InkWell(
        child: BoxShadowImage(
          child: img, size: size, bgColor: Colors.grey[300], borderRadius: 6,
          shadowBox: Rect.fromLTWH(15, 26, 275, 144),
          shadowColor: Color(0xFF4A4A4A).withOpacity(0.7),
          shadowRadius: 5.4, shadowBlurRadius: 24.5,
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