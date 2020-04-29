import 'package:movie_app/config/movie_section.dart';

import 'fetch_movies.dart';

class FetchRecommendationEvent extends FetchMoviesEvent {
  final int movieId;
  FetchRecommendationEvent(this.movieId, bool cache) : super(MovieSection.RECOMMENDATIONS, cache);

  @override
  String toString() => "FetchRecommendationEvent { movie_id: $movieId, section: ${super.toString()} }";
}