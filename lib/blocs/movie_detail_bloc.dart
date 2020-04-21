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

  var _castsPublishers = PublishSubject<PageOf<Cast>>();
  Stream<PageOf<Cast>> get casts => _castsPublishers.stream;

  var _recommendationPublishers = PublishSubject<PageOf<MovieBase>>();
  Stream<PageOf<MovieBase>> get recommendation => _recommendationPublishers.stream;

  var _videosPublishers = PublishSubject<PageOf<Video>>();
  Stream<PageOf<Video>> get videos => _videosPublishers.stream;

  var _reviewsPublishers = PublishSubject<PageOf<Review>>();
  Stream<PageOf<Review>> get reviews => _reviewsPublishers.stream;

  void loadCasts() {
    repository.getCasts(movie.id).then((value){
      if (!_castsPublishers.isClosed) {
        _castsPublishers.sink.add(PageOf.fromList(value));
      }
    });
  }

  void loadVideos() {
    repository.getVideos(movie.id).then((value){
      if (!_videosPublishers.isClosed) {
        _videosPublishers.sink.add(PageOf.fromList(value));
      }
    });
  }

  void loadRecommendedMovies(int page) {
    repository.getRecommendedMovies(movie.id, page).then((value){
      if (!_recommendationPublishers.isClosed) {
        _recommendationPublishers.sink.add(value);
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
      if (!_reviewsPublishers.isClosed){
         _reviewsPublishers.sink.add(value);
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

  @override
  void dispose() {
    _castsPublishers.close();
    _recommendationPublishers.close();
    _videosPublishers.close();
    _reviewsPublishers.close();
  }
}