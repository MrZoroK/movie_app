import 'fetch_page.dart';

class FetchReviewsEvent extends FetchPageEvent {
  FetchReviewsEvent(bool cache) : super(1, cache);

  @override
  String toString() => "FetchReviewsEvent { page: $page, cache: $cache }";
}