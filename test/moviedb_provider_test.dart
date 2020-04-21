import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:movie_app/config/constant.dart';
import 'package:movie_app/models.dart';
import 'package:test/test.dart';
import 'package:http/http.dart';

import 'package:movie_app/config/movie_section.dart';
import 'package:movie_app/resources.dart';

class MockClient extends Mock implements Client {}

void main() {
  group("MovieDbProvider", (){
    var client = MockClient();
    var movieDbProvider = MovieDbProvider(
      apiKey: API_KEY,
      baseUrl: API_BASE_URL,
      language: "en-US",
      client: client
    );
    int movieId = 419704;
    var headers = { "content-type": "application/json;charset=utf-8" };
    var pageParam = { "page": 1 };

    //==========================TEST getMovies==========================//
    MovieSection.values.forEach((section) async {
      String sectionUrl = section.url(movieId: movieId);
      String getVideosUrl = movieDbProvider.buildRequestUrl(sectionUrl, params: pageParam);
      test('getMovies(${section.toStr}) - HttpCode(200)', () async {
        when(client.get(getVideosUrl))
        .thenAnswer((_) async {
          final file = new File('test_resources/${section.toStr}.json');
          String response = "";
          if (file.existsSync()) {
            response = file.readAsStringSync();
          }
          return Response(response, 200, headers: headers);
        });

        PageOf<MovieBase> movies = await movieDbProvider.getMovies(sectionUrl, 1);
        expect(movies, const TypeMatcher<PageOf<MovieBase>>());
        expect(movies.items.length >= 2, true);//check if results parsed correctly
      });
      test('getMovies(${section.toStr}) - HttpCode(404)', () async {
        when(client.get(getVideosUrl))
        .thenAnswer((_) async {
          return Response('', 404);
        });

        expect(await movieDbProvider.getMovies(sectionUrl, 1), null);
      });
    });

    //==========================TEST getVideos==========================//
    String getVideosUrl = movieDbProvider.buildRequestUrl("/movie/$movieId/videos");
    test('getVideos($movieId) - HttpCode(200)', () async {
      when(client.get(getVideosUrl))
      .thenAnswer((_) async {
        final file = new File('test_resources/videos_$movieId.json');
        String response = "";
        if (file.existsSync()) {
          response = file.readAsStringSync();
        }
        return Response(response, 200, headers: headers);
      });

      var videos = await movieDbProvider.getVideos(movieId);
      expect(videos, const TypeMatcher<List<Video>>());
    });
    test('getVideos($movieId) - HttpCode(404)', () async {
      when(client.get(getVideosUrl))
      .thenAnswer((_) async {
        return Response('', 404);
      });

      var videos = await movieDbProvider.getVideos(movieId);
      expect(videos, null);
    });

    //==========================TEST getCasts==========================//
    String getCastsUrl = movieDbProvider.buildRequestUrl("/movie/$movieId/credits");
    test('getCasts($movieId) - HttpCode(200)', () async {
      when(client.get(getCastsUrl))
      .thenAnswer((_) async {
        final file = new File('test_resources/casts_$movieId.json');
        String response = "";
        if (file.existsSync()) {
          response = file.readAsStringSync();
        }
        return Response(response, 200, headers: headers);
      });

      var casts = await movieDbProvider.getCasts(movieId);
      expect(casts, const TypeMatcher<List<Cast>>());
    });
    test('getCasts($movieId) - HttpCode(404)', () async {
      when(client.get(getCastsUrl))
      .thenAnswer((_) async {
        return Response('', 404);
      });

      var casts = await movieDbProvider.getCasts(movieId);
      expect(casts, null);
    });

    //==========================TEST getReviews==========================//
    String getReviewUrl = movieDbProvider.buildRequestUrl("/movie/$movieId/reviews", params: pageParam);
    test('getReviews($movieId) - HttpCode(200)', () async {
      when(client.get(getReviewUrl))
      .thenAnswer((_) async {
        final file = new File('test_resources/reviews_$movieId.json');
        String response = "";
        if (file.existsSync()) {
          response = file.readAsStringSync();
        }
        return Response(response, 200, headers: headers);
      });

      var reviews = await movieDbProvider.getReviews(movieId, 1);
      expect(reviews, const TypeMatcher<PageOf<Review>>());
    });
    test('getReviews($movieId) - HttpCode(404)', () async {
      when(client.get(getReviewUrl))
      .thenAnswer((_) async {
        return Response('', 404);
      });

      var reviews = await movieDbProvider.getReviews(movieId, 1);
      expect(reviews, null);
    });

    client.close();
  });
}