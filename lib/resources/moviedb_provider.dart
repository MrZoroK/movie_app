import 'dart:convert';
import 'package:http/http.dart';
import 'package:movie_app/models/movie_detail.dart';
import 'dart:developer' as developer;

import '../models.dart';

class MovieDbProvider {
  final String apiKey;
  final String baseUrl;
  final String language;
  final Client client;
  MovieDbProvider({ this.apiKey, this.baseUrl, this.language = "en-US", this.client });

  dynamic _responseToJson(response) {
    if (response != null && response.statusCode == 200) {
      try {
        var utf8Res = utf8.decode(response.bodyBytes);
        var ret = json.decode(utf8Res);
        return ret;
      } catch (e) {
        developer.log('decode HttpResponse to Json failed', name: '_responseToJson', error: e);
      }
    }
    return null;
  }

  String buildRequestUrl(String path, { Map<String, dynamic> params }) {
    String url = baseUrl + path + "?api_key=$apiKey&language=$language";
    params?.forEach((key, value) {
      url += "&$key=$value";
    });
    return url;
  }

  Future<PageOf<MovieBase>> getMovies(String path, int page) {
    String url = buildRequestUrl(path, params: { "page": page} );
    return client.get(url).then((onValue){
      var jsObj = _responseToJson(onValue);
      if (jsObj != null) {
        return PageOf<MovieBase>.fromJson(jsObj);
      }
      return null;
    });
  }

  Future<MovieDetail> getMovie(int id) {
    String url = buildRequestUrl("/movie/$id");
    var request = client.get(url);
    return request.then((onValue){
      var jsObj = _responseToJson(onValue);
      if (jsObj != null) {
        return MovieDetail.fromJson(jsObj);
      }
      return null;
    });
  }

  Future<List<Video>> getVideos(int movieId) {
    String url = buildRequestUrl("/movie/$movieId/videos");
    return client.get(url).then((onValue){
      var jsObj = _responseToJson(onValue);
      if (jsObj != null) {
        return (jsObj["results"] as List)?.map((e) => e == null ? null : Video.fromJson(e))?.toList();
      }
      return null;
    });
  }

  Future<List<Cast>> getCasts(int movieId) {
    String url = buildRequestUrl("/movie/$movieId/credits");
    return client.get(url).then((onValue){
      var jsObj = _responseToJson(onValue);
      if (jsObj != null) {
        return (jsObj["cast"] as List)?.map((e) => e == null ? null : Cast.fromJson(e))?.toList();
      }
      return null;
    });
  }

  Future<PageOf<Review>> getReviews(int movieId, int page) {
    String url = buildRequestUrl("/movie/$movieId/reviews",
                                  params: {
                                    "page": page
                                  });
    return client.get(url).then((onValue){
      var jsObj = _responseToJson(onValue);
      if (jsObj != null) {
        return PageOf<Review>.fromJson(jsObj);
      }
      return null;
    });
  }
}