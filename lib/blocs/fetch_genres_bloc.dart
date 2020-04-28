import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/blocs/events/fetch_genres.dart';
import 'package:movie_app/blocs/fetch_page_bloc.dart';
import 'package:movie_app/models.dart';
import 'package:movie_app/models/genre.dart';
import 'package:movie_app/resources/movie_repository.dart';

import 'events/fetch_page.dart';
import 'states/fetch_page.dart';

class FetchGenresBloc extends FetchPageBloc {
  final MovieRepository repository = GetIt.I.get();
  
  @override
  FetchPageState get initialState => FetchPageStateNone();

  @override
  void onTransition(Transition<FetchPageEvent, FetchPageState> transition) {
    super.onTransition(transition);
    print(transition);
  } 

  @override
  Stream<FetchPageState> mapEventToState(FetchPageEvent event) {
    if (event is FetchGenresEvent) {
      return _mapFetchGenresEventToState(event);
    }
    return null;
  }

  Stream<FetchPageState> _mapFetchGenresEventToState(FetchGenresEvent event) async* {
    yield FetchPageStateLoading();
    try {
      final genres = await repository.getGenres(cache: event.cache);
      if (genres != null && genres.length > 0) {
        yield FetchPageStateSuccess(Page<Genre>.fromList(genres));
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