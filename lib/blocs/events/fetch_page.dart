abstract class FetchPageEvent {
  int page;
  bool cache;
  bool refreshing;
  FetchPageEvent(this.page, this.cache);
}