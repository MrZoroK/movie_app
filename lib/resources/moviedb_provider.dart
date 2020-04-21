import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'dart:developer' as developer;

import '../models.dart';

class MovieDbProvider {
  final String apiKey;
  final String baseUrl;
  final String language;
  final http.Client client;
  MovieDbProvider({ this.apiKey, this.baseUrl, this.language = "en-US", this.client });

  String buildRequestUrl(String path, { Map<String, dynamic> params }) {
    String url = baseUrl + path + "?api_key=$apiKey&language=$language";
    params?.forEach((key, value) {
      url += "&$key=$value";
    });
    return url;
  }

  static PageOf<MovieBase> _parseMoviePage(Uint8List responseBody) {
    try {
      var utf8String = utf8.decode(responseBody);
      var jsObj = json.decode(utf8String);
      if (jsObj != null) {
        return PageOf<MovieBase>.fromJson(jsObj);
      }
    } catch (e) {
      developer.log('decode HttpResponse to Json failed', name: '_responseToJson', error: e);
    }
    return null;
  }
  static List<Video> _parseVideos(Uint8List responseBody) {
    try {
      var utf8String = utf8.decode(responseBody);
      var jsObj = json.decode(utf8String);
      if (jsObj != null) {
        return (jsObj["results"] as List)?.map((e) => e == null ? null : Video.fromJson(e))?.toList();
      }
    } catch (e) {
      developer.log('decode HttpResponse to Json failed', name: '_responseToJson', error: e);
    }
    return null;
  }
  static List<Cast> _parseCasts(Uint8List responseBody) {
    try {
      var utf8String = utf8.decode(responseBody);
      var jsObj = json.decode(utf8String);
      if (jsObj != null) {
        return (jsObj["cast"] as List)?.map((e) => e == null ? null : Cast.fromJson(e))?.toList();
      }
    } catch (e) {
      developer.log('decode HttpResponse to Json failed', name: '_responseToJson', error: e);
    }
    return null;
  }
  static PageOf<Review> _parseReviews(Uint8List responseBody) {
    try {
      var utf8String = utf8.decode(responseBody);
      var jsObj = json.decode(utf8String);
      if (jsObj != null) {
        return PageOf<Review>.fromJson(jsObj);
      }
    } catch (e) {
      developer.log('decode HttpResponse to Json failed', name: '_responseToJson', error: e);
    }
    return null;
  }
  static List<ReviewDetail> _parseReviewDetails(String httpResp) {
    try {
      var httpDoc = parse(httpResp);
      var reviewContainers = httpDoc.getElementsByClassName("review_container");
      List<ReviewDetail> listReviewDetail = List();
      if (reviewContainers.length > 0) {
        var contents = reviewContainers[0].getElementsByClassName("content");
        contents.forEach((content) {

          ReviewDetail reviewDetail = ReviewDetail();
          var avatars = content.getElementsByClassName("avatar");
          if(avatars.length > 0) {
            var imgs = avatars[0].getElementsByTagName("img");
            if (imgs.length > 0 && imgs[0].attributes.length > 0) {
              reviewDetail.avatarUrl = imgs[0].attributes['data-src'];
            }
            var ratingWrappers = content.getElementsByClassName("rating_wrapper");
            if (ratingWrappers.length > 0) {
              var aTag = ratingWrappers[0].getElementsByTagName("a");
              if (aTag.length > 0 && aTag[0].attributes.length > 0) {
                reviewDetail.id = aTag[0].attributes['href']?.replaceAll("/review/", "");
              }
              var divTag = ratingWrappers[0].getElementsByTagName("div");
              if (divTag.length > 0) {
                reviewDetail.rateNum = divTag[0].text.trim();
              }
            }
            var info = content.getElementsByClassName("info");
            if (info.length > 0) {
              var h5Tag = info[0].getElementsByTagName("h5");
              if (h5Tag.length > 0) {
                int idx = h5Tag[0].text?.indexOf(" on ");
                if (idx >= 0) {
                  reviewDetail.datetime = h5Tag[0].text.substring(idx).replaceAll(" on ", "");
                }
              }
            }
          }

          listReviewDetail.add(reviewDetail);
        });
      }
      return listReviewDetail;
    } catch (e) {
      developer.log('decode HttpResponse to Json failed', name: '_responseToJson', error: e);
    }
    return null;
  }

  Future<PageOf<MovieBase>> getMovies(String path, int page) {
    String url = buildRequestUrl(path, params: { "page": page} );
    return client.get(url).then((resp){
      if (resp != null && resp.statusCode == 200) {
        return compute(_parseMoviePage, resp.bodyBytes);
      }
      return null;
    });
  }

  Future<List<Video>> getVideos(int movieId) {
    String url = buildRequestUrl("/movie/$movieId/videos");
    return client.get(url).then((resp){
      if (resp != null && resp.statusCode == 200) {
        return compute(_parseVideos, resp.bodyBytes);
      }
      return null;
    });
  }

  Future<List<Cast>> getCasts(int movieId) {
    String url = buildRequestUrl("/movie/$movieId/credits");
    return client.get(url).then((resp){
      if (resp != null && resp.statusCode == 200) {
        return compute(_parseCasts, resp.bodyBytes);
      }
      return null;
    });
  }

  Future<PageOf<Review>> getReviews(int movieId, int page) {
    String url = buildRequestUrl("/movie/$movieId/reviews",
                                  params: {
                                    "page": page
                                  });
    return client.get(url).then((resp){
      if (resp != null && resp.statusCode == 200) {
        return compute(_parseReviews, resp.bodyBytes);
      }
      return null;
    });
  }

  Future<List<ReviewDetail>> getReviewsDetail(MovieBase movie) {
    String tile = movie.title.replaceAll(" ", "-").replaceAll(":", "").toLowerCase();
    String url = "https://www.themoviedb.org/movie/${movie.id}-$tile/reviews";
    return http.get(url).then((resp) {
      if (resp != null && resp.statusCode == 200) {
        return compute(_parseReviewDetails, resp.body);
      }
      return null;
    });
  }
}