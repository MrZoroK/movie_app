import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/resources/movie_repository.dart';

import 'events/fetch_page.dart';
import 'states/fetch_page.dart';

abstract class FetchPageBloc extends Bloc<FetchPageEvent, FetchPageState> {
  final MovieRepository repository = GetIt.I.get();
}