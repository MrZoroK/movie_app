import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/events/fetch_page.dart';
import 'package:movie_app/blocs/fetch_page_bloc.dart';
import 'package:movie_app/blocs/states/fetch_page.dart';
import 'package:movie_app/models/page.dart';
import 'package:shimmer/shimmer.dart';

typedef ItemBuilder<T> = Widget Function(BuildContext context, T item);

class ExpandablePageView<T> extends StatefulWidget {
  final FetchPageEvent fetchMoreEvent;
  final ItemBuilder itemBuilder;
  final double height;
  final int dummySize;
  final Axis scrollDirection;
  final double verticalItemHeight;
  final bool pullToRefresh;

  ExpandablePageView({
    @required this.itemBuilder,
    @required this.fetchMoreEvent,
    @required this.height,
    this.dummySize = 3,
    this.scrollDirection = Axis.horizontal,
    this.verticalItemHeight = 0,
    this.pullToRefresh = true
  });

  @override
  _ExpandablePageViewState createState() => _ExpandablePageViewState();
}

class _ExpandablePageViewState<T> extends State<ExpandablePageView> with AutomaticKeepAliveClientMixin {
  Page<T> _expandableList;
  ScrollController _scrollCtrler;
  StreamController<bool> _streamCtrler = StreamController.broadcast();
  bool loadFromCache = true;
  bool get canExpand => _expandableList != null && _expandableList.page < _expandableList.totalPages;

  @override
  void initState() {
    super.initState();
    _scrollCtrler = ScrollController();
    if (widget.fetchMoreEvent != null) {
      //the first time of load
      loadFromCache = widget.fetchMoreEvent.cache;
    }
  }

  FetchPageEvent _createFetchPageEvent(int page) {
    var fetchMoreEvent = widget.fetchMoreEvent;
    fetchMoreEvent.page = page;
    fetchMoreEvent.cache = loadFromCache;
    return fetchMoreEvent;
  }

  void _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    loadFromCache = false;
    _loadPage(1);
  }

  void _loadPage(int page) {
    BlocProvider.of<FetchPageBloc>(context).add(_createFetchPageEvent(page));
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);//this needed for wantKeepAlive

    return Container(
      child: Stack(
        children: [
          BlocBuilder<FetchPageBloc, FetchPageState>(builder: (context, state){
            if (state is FetchPageStateNone) {
              _loadPage(1);
              return Container();
            } else if (state is FetchPageStateSuccess) {
              _extendPage(state.page);
              return _buildPage(state);
            } else {
              if (state is FetchPageStateError ) {
                //TODO: show error popup
              }
              if (_expandableList == null) {
                return _buildDummyPage();
              } else {
                return _buildPage(state);
              }
            }
          }),
          widget.pullToRefresh ? _refreshIndicator() : Container()
        ],
      ),
    );
  }

  Widget _buildDummyPage() {
    List<T> dummy = List.generate(widget.dummySize, (index) => null);
    double veticalHeight = min(widget.height, widget.dummySize * widget.verticalItemHeight);

    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[50],
      child: Container(
        height: widget.scrollDirection == Axis.horizontal ? widget.height : veticalHeight,
        child: ListView(
          scrollDirection: widget.scrollDirection,
          children: dummy.map((e){
            return widget.itemBuilder(context, e);
          }).toList(),
        ),
      )
    );
  }

  double calcHeight (int itemCount) {
    if (itemCount == 0) {
      return 0;
    }
    double veticalHeight = min(widget.height, itemCount * widget.verticalItemHeight);
    return widget.scrollDirection == Axis.horizontal ? widget.height : veticalHeight;
  }

  void _extendPage(Page<T> newData) {
    if (_expandableList == null) {
      _expandableList = newData;
    } else {
      _expandableList.append(newData);
    }
    if (canExpand) {
      _expandableList.items.add(null);
      //dummy at last for loadmore button or loading icon
    }
  }

  _onPullListener(event) async {
    if (!widget.pullToRefresh) {
      return;
    }
    if (widget.scrollDirection == Axis.horizontal) {
      if (event.delta.dx > 10.0 && _scrollCtrler.position.pixels == _scrollCtrler.position.minScrollExtent) {
        _streamCtrler.add(true);
      }
    } else {
      if (event.delta.dy > 10.0 && _scrollCtrler.position.pixels == _scrollCtrler.position.minScrollExtent) {
        _streamCtrler.add(true);
      }
    }
  }

  Widget _buildLoadMoreButton() {
    return Center(
      child: FlatButton(
        child: Container(
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.play_arrow, color: Color(0xFF00CBCF), size: 50
              ),
              Text("Load more"),
            ],
          ),
        ),
        onPressed: (){
          _loadPage(_expandableList.page + 1);
        },
      ),
    );
  }

  Widget _buildPage(FetchPageState state) {
    int itemCount = _expandableList.items.length;

    _streamCtrler.add(false);
    return Container(
      height: calcHeight(itemCount),
      child: Listener(
        onPointerMove: _onPullListener,
        child: ListView.builder(
          itemCount: itemCount,
          scrollDirection: widget.scrollDirection,
          controller: _scrollCtrler,
          itemBuilder: (ctx, index){
            if (index == itemCount - 1 && _expandableList.items[index] == null) {
              if (state is FetchPageStateLoading) {
                return Container(
                  width: 100,
                  child: Center(child: CircularProgressIndicator())
                );
              } else {
                return _buildLoadMoreButton();
              }
            } else {
              return widget.itemBuilder(context, _expandableList.items[index]);
            }
          },
        ),
      ),
    );
  }

  Widget _refreshIndicator() {
    return StreamBuilder(
      stream: _streamCtrler.stream.distinct(),
      initialData: false,
      builder: (context, snapshot){
        if (snapshot.hasData) {
          if (snapshot.data) {
            _refresh();
            return ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  height: widget.height,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: widget.height / 3),
                  child: CircularProgressIndicator()
                ),
              ),
            );
          }
        }
        return Container();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}