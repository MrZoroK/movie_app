import 'package:movie_app/models/movie_detail.dart';

import '../config/movie_section.dart';
import '../models.dart';
import '../resources.dart';

class MovieRepository {
  final MovieDbProvider movieDbProvider;
  final MySQLProvider mySQLProvider;
  MovieRepository({this.movieDbProvider, this.mySQLProvider});

  Future<PageOf<MovieBase>> getMovies(MovieSection movieSection, {int page = 1}) {
    return movieDbProvider.getMovies(movieSection.url(), page);
  }

  Future<MovieDetail> getMovie(int id) {
    return null;
  }
}