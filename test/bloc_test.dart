import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app/blocs.dart';
import 'package:movie_app/blocs/states/fetch_page.dart';
import 'package:movie_app/config/movie_section.dart';
import 'package:movie_app/models.dart';
import 'package:movie_app/resources/movie_repository.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  group("test fetch movies bloc", (){
    FetchMoviesBloc fetchMoviesBloc;
    MovieRepository movieRepository = MockMovieRepository();
    GetIt.I.registerSingleton(movieRepository);
    
    setUp((){
      fetchMoviesBloc = FetchMoviesBloc();
    });

    test("after initialized bloc state is correct", (){
      expect(FetchPageStateNone(), fetchMoviesBloc.initialState);
    });

    test("emits success state after issue load event", (){
      final file = new File('test_resources/popular.json');
      Page<MovieBase> popular;

      if (file.existsSync()) {
        var jsonObj = json.decode(file.readAsStringSync());
        popular = Page<MovieBase>.fromJson(jsonObj);
      }

      expectLater(fetchMoviesBloc, emitsInOrder([
        FetchPageStateNone(), FetchPageStateLoading(), FetchPageStateSuccess(popular)
      ]));

      when(movieRepository.getMovies(MovieSection.POPULAR, page: 1, cache: false))
        .thenAnswer((_)async {
          return popular;
        });

      fetchMoviesBloc.add(FetchMoviesEvent(MovieSection.POPULAR, false));
    });

    test("after closed bloc does not emit any state", (){
      expectLater(fetchMoviesBloc, emitsInOrder([FetchPageStateNone(), emitsDone]));
      fetchMoviesBloc.close();
    });

    tearDown((){
      fetchMoviesBloc?.close();
    });
  });
}