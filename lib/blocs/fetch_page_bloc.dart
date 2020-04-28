import 'package:bloc/bloc.dart';

import 'events/fetch_page.dart';
import 'states/fetch_page.dart';

abstract class FetchPageBloc extends Bloc<FetchPageEvent, FetchPageState> {}