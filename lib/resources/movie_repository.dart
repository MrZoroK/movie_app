import '../config/movie_section.dart';
import '../models.dart';
import '../resources.dart';

class MovieRepository {
  final MovieDbProvider movieDbProvider;
  MovieRepository({this.movieDbProvider});

  Future<PageOf<MovieBase>> getMovies(MovieSection movieSection, {int page = 1, bool cache = true}) {
    return movieDbProvider.getMovies(movieSection.url(), page, useCache: cache);
  }

  Future<PageOf<MovieBase>> getRecommendedMovies(int movieId, int page, {bool cache = true}) {
    return movieDbProvider.getMovies(MovieSection.RECOMMENDATIONS.url(movieId: movieId), page, useCache: cache);
  }

  Future<List<Video>> getVideos(int movieId, {bool cache = true}) {
    return movieDbProvider.getVideos(movieId, useCache: cache);
  }

  Future<List<Cast>> getCasts(int movieId, {bool cache = true}) {
    return movieDbProvider.getCasts(movieId, useCache: cache);
  }

  Future<PageOf<Review>> getReviews(int movieId, int page, {bool cache = true}) {
    return movieDbProvider.getReviews(movieId, page, useCache: cache);
  }

  Future<List<ReviewDetail>> getReviewsDetail(MovieBase movie, {bool cache = true}) {
    return movieDbProvider.getReviewsDetail(movie);
  }

  Future<List<Genre>> getGenres({bool cache = true}) {
    return movieDbProvider.getGenres(useCache: cache);
  }

  Future<List<VideoDetail>> getVideoDetails(String videoId, {bool cache = true}) {
    return movieDbProvider.getVideoDetails(videoId, useCache: cache);
  }
}