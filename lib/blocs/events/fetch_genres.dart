import 'fetch_page.dart';

class FetchGenresEvent extends FetchPageEvent {
  FetchGenresEvent(bool cache) : super(cache: cache);

  @override
  String toString() => "FetchGenresEvent { cache: $cache }";
}