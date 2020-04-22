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

  Future<PageOf<MovieBase>> getRecommendedMovies(int movieId, int page) {
    return movieDbProvider.getMovies(MovieSection.RECOMMENDATIONS.url(movieId: movieId), page);
  }

  Future<List<Video>> getVideos(int movieId) {
    return movieDbProvider.getVideos(movieId);
  }

  Future<List<Cast>> getCasts(int movieId) {
    return movieDbProvider.getCasts(movieId);
  }

  Future<PageOf<Review>> getReviews(int movieId, int page) {
    return movieDbProvider.getReviews(movieId, page);
  }

  Future<List<ReviewDetail>> getReviewsDetail(MovieBase movie) {
    return movieDbProvider.getReviewsDetail(movie);
  }

  Future<List<Genre>> getGenres() {
    return movieDbProvider.getGenres();
  }

  Future<List<VideoDetail>> getVideoDetails(String videoId) {
    return movieDbProvider.getVideoDetails(videoId);
  }
}