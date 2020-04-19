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

  void loadMovies(MovieSection section, int page) {
    repository.getMovies(section, page: page).then((value){
      _pageOfMoviesPublishers[section.index].sink.add(value);
    });
  }
  @override
  void dispose() {
    _pageOfMoviesPublishers.forEach((element) {
      element.close();
    });
  }

}