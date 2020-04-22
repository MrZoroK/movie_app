import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shimmer/shimmer.dart';

import 'package:movie_app/models.dart';

typedef LoadMoreCallback = void Function(int nextPage, bool fromCache);
typedef ItemBuilder<T> = Widget Function(BuildContext context, T item);

class ExpandableListView<T> extends StatefulWidget {
  final Stream<PageOf<T>> stream;
  final LoadMoreCallback onLoadMore;
  final ItemBuilder itemBuilder;
  final double height;
  final int dummySize;
  final Axis scrollDirection;
  final double verticalItemHeight;
  final bool pullToRefresh;

  ExpandableListView({
    @required this.stream,
    @required this.itemBuilder,
    @required this.onLoadMore,
    @required this.height,
    this.dummySize = 3,
    this.scrollDirection = Axis.horizontal,
    this.verticalItemHeight = 0,
    this.pullToRefresh = true
  });

  @override
  _ExpandableListViewState createState() => _ExpandableListViewState<T>();
}

class _ExpandableListViewState<T> extends State<ExpandableListView> with AutomaticKeepAliveClientMixin  {
  PageOf<T> _expandableList;
  ScrollController _scrollCtrler;
  StreamController<bool> _streamCtrler = StreamController.broadcast();
  bool loadFromCache = true;
  bool get canLoadMore => _expandableList != null && _expandableList.page < _expandableList.totalPages;

  void _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _expandableList = null;
    loadFromCache = false;
    widget.onLoadMore(1, loadFromCache);
  }
  void _loadMore() {
    if (canLoadMore) {
      widget.onLoadMore(_expandableList.page + 1, loadFromCache);
    }
  }

  @override void initState() {
    super.initState();
    _scrollCtrler = ScrollController();
    if (widget.onLoadMore != null) {
      //the first time of load
      widget.onLoadMore(1, loadFromCache);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);//this needed for wantKeepAlive

    return Container(
      child: Stack(
        children: [
          StreamBuilder(
            stream: widget.stream,
            builder: (context, snapshot){
              if (!snapshot.hasData) {
                return _dummyList();
              } else {
                return _updateList(snapshot.data);
              }
            },
          ),
          widget.pullToRefresh ? _refreshIndicator() : Container()
        ],
      ),
    );
  }

  Widget _dummyList() {
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
  Widget _updateList(PageOf<T> newData) {
    if (_expandableList == null) {
      _expandableList = newData;
    } else {
      _expandableList.append(newData);
    }
    if (canLoadMore) {
      _expandableList.items.add(null);//dummy at last
    }
    int itemCount = _expandableList.items.length;

    _streamCtrler.add(false);
    return Container(
      height: calcHeight(itemCount),
      child: Listener(
        onPointerMove: (event) async {
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
        },
        child: ListView.builder(
          itemCount: itemCount,
          scrollDirection: widget.scrollDirection,
          controller: _scrollCtrler,
          itemBuilder: (context, index){
            if (index == itemCount - 1 && _expandableList.items[index] == null) {
              return Center(
                child: FlatButton(
                  child: Container(
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
                  onPressed: _loadMore,
                ),
              );
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
  void dispose() {
    _streamCtrler.close();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}