import 'fetch_page.dart';

class FetchGenresEvent extends FetchPageEvent {
  FetchGenresEvent(bool cache) : super(1, cache);

  @override
  String toString() => "FetchGenresEvent { page: $page, cache: $cache }";
}