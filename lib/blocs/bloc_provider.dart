//Generic Interface for all BLoCs
import 'package:flutter/material.dart';

abstract class BlocBase {
  void dispose();
}

class _InternalProvider<T extends BlocBase> extends InheritedWidget {
  final T bloc;

  const _InternalProvider({
    Key key,
    this.bloc,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InternalProvider<T> oldWidget) {
    return oldWidget.bloc != bloc;
  }
}

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final Widget child;
  final T Function(BuildContext context, T bloc) builder;

  BlocProvider({
    Key key,
    @required this.builder,
    @required this.child,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    _InternalProvider<T> provider = context.dependOnInheritedWidgetOfExactType();
    return provider.bloc;
  }
}

class _BlocProviderState<T extends BlocBase> extends State<BlocProvider<T>> {
  T bloc;

  @override
  Widget build(BuildContext context) {
    return _InternalProvider(
      bloc: bloc,
      child: widget.child,
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.builder != null) {
      bloc = widget.builder(context, bloc);
    }
  }

  @override
  void dispose() {
    bloc?.dispose();
    super.dispose();
  }
} 