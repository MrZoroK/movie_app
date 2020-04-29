import 'package:movie_app/blocs/events/fetch_page.dart';
import 'package:movie_app/blocs/events/fetch_videos.dart';
import 'package:movie_app/blocs/fetch_page_bloc.dart';
import 'package:movie_app/blocs/states/fetch_page.dart';
import 'package:movie_app/models.dart';

class FetchVideosBloc extends FetchPageBloc {
  @override
  FetchPageState get initialState => FetchPageStateNone();

  @override
  Stream<FetchPageState> mapEventToState(FetchPageEvent event) {
    if (event is FetchVideosEvent) {
      return _mapFetchVideosEventToState(event);
    }
    return null;
  }

  Stream<FetchPageState> _mapFetchVideosEventToState(FetchVideosEvent event) async* {
    yield FetchPageStateLoading();
    try {
      final videos = await repository.getVideos(event.movieId, cache: event.cache);
      if (videos != null && videos.length > 0) {
        yield FetchPageStateSuccess(Page<Video>.fromList(videos));
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