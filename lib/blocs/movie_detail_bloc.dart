import 'package:get_it/get_it.dart';
import 'package:movie_app/models.dart';
import 'package:movie_app/resources/movie_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../blocs.dart';

class MovieDetailBloc extends BlocBase {
  final MovieBase movie;

  MovieDetailBloc(this.movie);

  final MovieRepository repository = GetIt.I.get();

  var _castsPublishers = PublishSubject<PageOf<Cast>>();
  Stream<PageOf<Cast>> get casts => _castsPublishers.stream;

  var _recommendationPublishers = PublishSubject<PageOf<MovieBase>>();
  Stream<PageOf<MovieBase>> get recommendation => _recommendationPublishers.stream;

  void loadCasts() {
    repository.getCasts(movie.id).then((value){
      _castsPublishers.sink.add(PageOf.fromList(value));
    });
  }

  void loadRecommendedMovies(int page) {
    repository.getRecommendedMovies(movie.id, page).then((value){
      _recommendationPublishers.sink.add(value);
    });
  }
  @override
  void dispose() {
    _castsPublishers.close();
    _recommendationPublishers.close();
  }
}