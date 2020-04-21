import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shimmer/shimmer.dart';

import 'package:movie_app/models.dart';

typedef LoadMoreCallback = void Function(int nextPage);
typedef ItemBuilder<T> = Widget Function(BuildContext context, T item);

class ExpandableListView<T> extends StatefulWidget {
  final Stream<PageOf<T>> stream;
  final LoadMoreCallback onLoadMore;
  final ItemBuilder itemBuilder;
  final double height;
  final int dummySize;
  final Axis scrollDirection;
  final double verticalItemHeight;

  ExpandableListView({
    @required this.stream,
    @required this.itemBuilder,
    @required this.onLoadMore,
    @required this.height,
    this.dummySize = 3,
    this.scrollDirection = Axis.horizontal,
    this.verticalItemHeight = 0
  });

  @override
  _ExpandableListViewState createState() => _ExpandableListViewState<T>();
}

class _ExpandableListViewState<T> extends State<ExpandableListView> with AutomaticKeepAliveClientMixin  {
  PageOf<T> _expandableList;
  ScrollController _scrollCtrler;
  StreamController<bool> _streamCtrler = StreamController.broadcast();



  _scrollListener() {
    if (_scrollCtrler.offset >= _scrollCtrler.position.maxScrollExtent &&
        !_scrollCtrler.position.outOfRange) {
      _loadMore();
    }
  }

  bool get canLoadMore => _expandableList != null && _expandableList.page < _expandableList.totalPages;

  void _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _expandableList = null;
    widget.onLoadMore(1);
  }
  void _loadMore() {
    if (canLoadMore) {
      widget.onLoadMore(_expandableList.page + 1);
    }
  }

  @override void initState() {
    super.initState();
    _scrollCtrler = ScrollController();
    _scrollCtrler.addListener(_scrollListener);
    if (widget.onLoadMore != null) {
      //the first time of load
      widget.onLoadMore(1);
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
          _refreshIndicator()
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
      //TODO: remove this when appending
    }
    int itemCount = _expandableList.items.length;

    _streamCtrler.add(false);
    return Container(
      height: calcHeight(itemCount),
      child: Listener(
        onPointerMove: (event) async {
          if (widget.scrollDirection == Axis.horizontal) {
            if (event.delta.dx > 5.0 && _scrollCtrler.position.pixels == _scrollCtrler.position.minScrollExtent) {
              _streamCtrler.add(true);
            }
          } else {
            if (event.delta.dy > 5.0 && _scrollCtrler.position.pixels == _scrollCtrler.position.minScrollExtent) {
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
              return FlatButton(
                child: Text("Load more"),
                onPressed: _loadMore,
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