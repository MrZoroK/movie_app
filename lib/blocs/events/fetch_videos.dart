import 'package:movie_app/blocs/events/fetch_page.dart';

class FetchVideosEvent extends FetchPageEvent {
  final int movieId;
  FetchVideosEvent(this.movieId, bool cache) : super(cache: cache);

  @override
  String toString() => "FetchVideosEvent { movie_id: $movieId, cache: $cache }";
}