import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../models.dart';

typedef LoadMoreCallback = void Function(int nextPage);
typedef ItemBuilder<T> = Widget Function(BuildContext context, T item);

class ExpandableListView<T> extends StatefulWidget {
  final Stream<PageOf<T>> stream;
  final LoadMoreCallback onLoadMore;
  final ItemBuilder itemBuilder;
  final double height;
  final int dummySize;

  ExpandableListView({
    @required this.stream,
    @required this.itemBuilder,
    @required this.onLoadMore,
    @required this.height,
    this.dummySize = 3
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
    _scrollCtrler = ScrollController();
    _scrollCtrler.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);//this needed for wantKeepAlive

    return Container(
      height: widget.height,
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
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[50],
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: dummy.map((e){
          return widget.itemBuilder(context, e);
        }).toList(),
      )
    );
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
    return Listener(
      onPointerMove: (event) async {
        if (event.delta.dx > 5.0 && _scrollCtrler.position.pixels == _scrollCtrler.position.minScrollExtent) {
          _streamCtrler.add(true);
        }
      },
      child: ListView.builder(
        itemCount: itemCount,
        scrollDirection: Axis.horizontal,
        controller: _scrollCtrler,
        itemBuilder: (context, index){
          if (index == itemCount - 1) {
            return FlatButton(
              child: Text("Load more"),
              onPressed: _loadMore,
            );
          } else {
            return widget.itemBuilder(context, _expandableList.items[index]);
          }
        },
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