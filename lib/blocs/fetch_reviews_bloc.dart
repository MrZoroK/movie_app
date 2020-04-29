import 'package:bloc/bloc.dart';

import 'package:movie_app/models.dart';
import 'events/fetch_page.dart';
import 'events/fetch_reviews.dart';
import 'fetch_page_bloc.dart';
import 'states/fetch_page.dart';

class FetchReviewsBloc extends FetchPageBloc {
  final MovieBase movie;
  List<ReviewDetail> _listReviewDetails = List();
  
  FetchReviewsBloc(this.movie);
  
  @override
  FetchPageState get initialState => FetchPageStateNone();

  @override
  void onTransition(Transition<FetchPageEvent, FetchPageState> transition) {
    super.onTransition(transition);
    print(transition);
  } 

  @override
  Stream<FetchPageState> mapEventToState(FetchPageEvent event) {
    if (event is FetchReviewsEvent) {
      return _mapFetchReviewsEventToState(event);
    }
    return null;
  }

  Future<Page<Review>> _internalLoadReviews(int page, bool cache) {
    return repository.getReviews(movie.id, page, cache: cache).then((reviews){
      reviews.items.forEach((review) {
        _listReviewDetails.forEach((detail) {
          if (review.id == detail.id) {
            review.detail = detail;
          }
        });
      });
      return reviews;
    });
  }
  Future<Page<Review>> _loadReviews(int page, bool cache) {
    if (_listReviewDetails.length > 0) {
      return _internalLoadReviews(page, cache);
    } else {
      return repository.getReviewsDetail(movie, cache: cache).then((reviewDetails){
         _listReviewDetails = reviewDetails;
        return _internalLoadReviews(page, cache);
      });
    }
  }

  Stream<FetchPageState> _mapFetchReviewsEventToState(FetchReviewsEvent event) async* {
    yield FetchPageStateLoading();
    try {
      final reviews = await _loadReviews(event.page, event.cache);
      if (reviews != null && reviews.items.length > 0) {
        yield FetchPageStateSuccess(reviews);
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