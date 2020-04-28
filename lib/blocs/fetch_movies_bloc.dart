import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/blocs/events/fetch_recommedations.dart';
import 'package:movie_app/resources/movie_repository.dart';

import 'events/fetch_movies.dart';
import 'events/fetch_page.dart';
import 'fetch_page_bloc.dart';
import 'states/fetch_page.dart';

class FetchMoviesBloc extends FetchPageBloc {
  final MovieRepository repository = GetIt.I.get();
  
  @override
  FetchPageState get initialState => FetchPageStateNone();

  @override
  Stream<FetchPageState> mapEventToState(FetchPageEvent event) {
    if (event is FetchMoviesEvent) {
      return _mapFetchMoviesEventToState(event);
    }
    return null;
  }

  @override
  void onTransition(Transition<FetchPageEvent, FetchPageState> transition) {
    super.onTransition(transition);
    print(transition);
  } 

  Stream<FetchPageState> _mapFetchMoviesEventToState(FetchMoviesEvent event) async* {
    yield FetchPageStateLoading();
    try {
      final page = await (event is FetchRecommendationEvent
      ? repository.getRecommendedMovies(event.movieId, event.page, cache: event.cache)
      : repository.getMovies(event.movieSection, page: event.page, cache: event.cache));

      if (page != null && page.items.length > 0) {
        yield FetchPageStateSuccess(page);
      } else {
        yield FetchPageStateError("Empty Page");
      }
    } catch (e) {
      yield e is FetchPageStateError 
      ? FetchPageStateError(e.error)
      : FetchPageStateError(e.toString());
    }
  }

}