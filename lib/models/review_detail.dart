class ReviewDetail {
  String id;
  String rateNum;
  String avatarUrl;
  String datetime;

  @override
  bool operator ==(dynamic other) {
    return other is ReviewDetail && id == other.id;
  }
  @override
  int get hashCode => super.hashCode;
}