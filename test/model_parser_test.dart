import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/config/movie_section.dart';
import 'package:movie_app/models.dart';

void main() {
  int movieId = 419704;

  MovieSection.values.forEach((section) async {
    test("test MovieBases(${section.toStr}) parser", (){
      final file = new File('test_resources/${section.toStr}.json');
      Page<MovieBase> popular;

      expect(file.existsSync(), true, reason: "no ${section.toStr}.json file");
      if (file.existsSync()) {
        var jsonObj = json.decode(file.readAsStringSync());
        popular = Page<MovieBase>.fromJson(jsonObj);
        expect(popular != null && popular.items.length >= 2, true, reason: "invalid movies ${section.toStr}");
      }
      
    });
  });

  test("test Reviews parser", (){
    final file = new File('test_resources/reviews_$movieId.json');
    Page<Review> reviews;

    expect(file.existsSync(), true, reason: "no reviews_$movieId.json file");
    if (file.existsSync()) {
      var jsonObj = json.decode(file.readAsStringSync());
      reviews = Page<Review>.fromJson(jsonObj);
    }
    expect(reviews != null && reviews.items.length >= 2, true);
  });

  test("test Videos parser", (){
    final file = new File('test_resources/videos_$movieId.json');
    List<Video> videos;

    expect(file.existsSync(), true, reason: "no videos_$movieId.json file");
    if (file.existsSync()) {
      var jsonObj = json.decode(file.readAsStringSync());
      videos = (jsonObj["results"] as List)?.map((e) => e == null ? null : Video.fromJson(e))?.toList();
    }
    expect(videos != null && videos.length >= 2, true);
  });

  test("test Casts parser", (){
    final file = new File('test_resources/casts_$movieId.json');
    List<Cast> casts;

    expect(file.existsSync(), true, reason: "no casts_$movieId.json file");
    if (file.existsSync()) {
      var jsonObj = json.decode(file.readAsStringSync());
      casts = (jsonObj["cast"] as List)?.map((e) => e == null ? null : Cast.fromJson(e))?.toList();
    }
    expect(casts != null && casts.length >= 2, true);
  });
}