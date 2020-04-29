import 'package:get_it/get_it.dart';
import 'package:movie_app/models.dart';
import 'package:movie_app/resources/movie_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../blocs.dart';

class MovieDetailBloc extends BlocBase {
  final MovieBase movie;

  MovieDetailBloc(this.movie);

  final MovieRepository repository = GetIt.I.get();

  var _castsPublisher = PublishSubject<Page<Cast>>();
  Stream<Page<Cast>> get casts => _castsPublisher.stream;

  var _recommendationsPublisher = PublishSubject<Page<MovieBase>>();
  Stream<Page<MovieBase>> get recommendation => _recommendationsPublisher.stream;

  var _genresPublisher = PublishSubject<List<String>>();
  Stream<List<String>> get genres => _genresPublisher.stream;

  void loadCasts(bool cache) {
    repository.getCasts(movie.id, cache: cache).then((value){
      if (!_castsPublisher.isClosed) {
        _castsPublisher.sink.add(Page.fromList(value));
      }
    });
  }

  Future<String> loadVideoUrl(String videoId, bool cache) {
    return repository.getVideoDetails(videoId, cache: cache).then((videoDetails){
      if (videoDetails != null && videoDetails.length > 0) {
        return videoDetails[0].url;
      }
      return "";
    });
  }

  void loadRecommendedMovies(int page, bool cache) {
    repository.getRecommendedMovies(movie.id, page, cache: cache).then((value){
      if (!_recommendationsPublisher.isClosed) {
        _recommendationsPublisher.sink.add(value);
      }
    });
  }

  void loadGenres(bool cache) {
    repository.getGenres(cache: cache).then((allGenres){
      if (allGenres != null) {
        List<String> movieGenres = List();
        allGenres.forEach((genre) {
          movie.genreIds.forEach((genreId) {
            if (genre.id == genreId) {
              movieGenres.add(genre.name);
            }
          });
        });
        movieGenres.sort((a, b) => a.length.compareTo(b.length));
        
        if (!_genresPublisher.isClosed) {
          _genresPublisher.sink.add(movieGenres);
        }
      }
    });
  }

  @override
  void dispose() {
    _castsPublisher.close();
    _recommendationsPublisher.close();
    _genresPublisher.close();
  }
}