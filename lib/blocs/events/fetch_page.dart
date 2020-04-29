abstract class FetchPageEvent {
  int page;
  bool cache;
  FetchPageEvent({this.page =  1, this.cache = true});

  @override
  String toString() => "FetchPageEvent { page: $page, cache: $cache }";
}