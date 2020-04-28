import 'package:equatable/equatable.dart';
import 'package:movie_app/models.dart';

abstract class FetchPageState extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPageStateNone extends FetchPageState {
  @override
  String toString() => 'FetchPageStateNone';
}

class FetchPageStateLoading extends FetchPageState {
  @override
  String toString() => 'FetchPageStateLoading';
}

class FetchPageStateError extends FetchPageState {
  final String error;

  FetchPageStateError(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FetchPageStateError{ error: $error }';
}

class FetchPageStateSuccess<T> extends FetchPageState {
  final Page<T> page;

  FetchPageStateSuccess(this.page);

  @override
  List<Object> get props => [page];

  @override
  String toString() => 'FetchPageStateSuccess{ items: ${page.items.length} }';
}