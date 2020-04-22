import 'package:get_it/get_it.dart';
import 'package:movie_app/models.dart';
import 'package:movie_app/resources/movie_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../blocs.dart';

class MovieDetailBloc extends BlocBase {
  final MovieBase movie;
  List<ReviewDetail> _listReviewDetails = List();

  MovieDetailBloc(this.movie);

  final MovieRepository repository = GetIt.I.get();

  var _castsPublisher = PublishSubject<PageOf<Cast>>();
  Stream<PageOf<Cast>> get casts => _castsPublisher.stream;

  var _recommendationsPublisher = PublishSubject<PageOf<MovieBase>>();
  Stream<PageOf<MovieBase>> get recommendation => _recommendationsPublisher.stream;

  var _videosPublisher = PublishSubject<PageOf<Video>>();
  Stream<PageOf<Video>> get videos => _videosPublisher.stream;

  var _reviewsPublisher = PublishSubject<PageOf<Review>>();
  Stream<PageOf<Review>> get reviews => _reviewsPublisher.stream;

  var _genresPublisher = PublishSubject<List<String>>();
  Stream<List<String>> get genres => _genresPublisher.stream;

  void loadCasts() {
    repository.getCasts(movie.id).then((value){
      if (!_castsPublisher.isClosed) {
        _castsPublisher.sink.add(PageOf.fromList(value));
      }
    });
  }

  void loadVideos() {
    repository.getVideos(movie.id).then((value){
      if (!_videosPublisher.isClosed) {
        _videosPublisher.sink.add(PageOf.fromList(value));
      }
    });
  }

  Future<String> loadVideoUrl(String videoId) {
    return repository.getVideoDetails(videoId).then((videoDetails){
      if (videoDetails != null && videoDetails.length > 0) {
        return videoDetails[0].url;
      }
      return "";
    });
  }

  void loadRecommendedMovies(int page) {
    repository.getRecommendedMovies(movie.id, page).then((value){
      if (!_recommendationsPublisher.isClosed) {
        _recommendationsPublisher.sink.add(value);
      }
    });
  }

  void _internalLoadReviews(int page) {
    repository.getReviews(movie.id, page).then((value){
      value.items.forEach((review) {
        _listReviewDetails.forEach((detail) {
          if (review.id == detail.id) {
            review.detail = detail;
          }
        });
      });
      if (!_reviewsPublisher.isClosed){
         _reviewsPublisher.sink.add(value);
      }
    });
  }
  void loadReviews(int page) {
    if (_listReviewDetails.length > 0) {
      _internalLoadReviews(page);
    } else {
      repository.getReviewsDetail(movie).then((value){
         _listReviewDetails = value;
        _internalLoadReviews(page);
      });
    }
  }
  void loadGenres() {
    repository.getGenres().then((allGenres){
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
    });
  }

  @override
  void dispose() {
    _castsPublisher.close();
    _recommendationsPublisher.close();
    _videosPublisher.close();
    _reviewsPublisher.close();
    _genresPublisher.close();
  }
}