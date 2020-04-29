import 'fetch_page.dart';

class FetchReviewsEvent extends FetchPageEvent {
  FetchReviewsEvent(bool cache) : super(cache: cache);

  @override
  String toString() => "FetchReviewsEvent { cache: $cache }";
}