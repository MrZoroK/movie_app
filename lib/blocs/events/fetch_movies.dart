import 'package:movie_app/config/movie_section.dart';
import 'fetch_page.dart';

class FetchMoviesEvent extends FetchPageEvent {
  final MovieSection movieSection;
  FetchMoviesEvent(this.movieSection, bool cache) : super(1, cache);

  @override
  String toString() => "FetchMoviesEvent { section: ${movieSection.toStr}, page: $page, cache: $cache }";
}