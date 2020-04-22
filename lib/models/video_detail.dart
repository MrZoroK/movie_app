class VideoDetail {
  String qualityLabel;
  int itag;
  String url;
  
  factory VideoDetail.fromJson(Map<String, dynamic> json){
    return VideoDetail(
      qualityLabel: json['qualityLabel'] as String,
      itag: json['itag'] as int,
      url: json['url'] as String,
    );
  }

  VideoDetail({
    this.qualityLabel,
    this.itag,
    this.url
  });
}