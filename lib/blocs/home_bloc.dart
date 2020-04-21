import 'package:get_it/get_it.dart';
import 'package:movie_app/blocs.dart';
import 'package:movie_app/config/movie_section.dart';
import 'package:movie_app/models.dart';
import 'package:movie_app/resources/movie_repository.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends BlocBase {
  final MovieRepository repository = GetIt.I.get();

  var _pageOfMoviesPublishers = List.generate(4, (index) => PublishSubject<PageOf<MovieBase>>());
  Stream<PageOf<MovieBase>> movies(MovieSection section) => _pageOfMoviesPublishers[section.index].stream;

  var _genresPublisher = PublishSubject<PageOf<Genre>>();
  Stream<PageOf<Genre>> get genres => _genresPublisher.stream;

  void loadMovies(MovieSection section, int page) {
    repository.getMovies(section, page: page).then((value){
      if (!_pageOfMoviesPublishers[section.index].isClosed) {
        _pageOfMoviesPublishers[section.index].sink.add(value);
      }
    });
  }

  void loadGenres() {
    repository.getGenres().then((value){
      if (!_genresPublisher.isClosed) {
        _genresPublisher.sink.add(PageOf.fromList(value));
      }
    });
  }
  @override
  void dispose() {
    _pageOfMoviesPublishers.forEach((element) {
      element.close();
    });
    _genresPublisher.close();
  }

}