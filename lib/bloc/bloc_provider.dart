import 'package:flutter/material.dart';

///****** ****** 使用时自定义BlocBase中的需要的公共方法，然后继承实例化后传入BlocProvider的bloc参数中 ****** ****** ****** /
//基础的bloc类，类似于MVP中的asePresenter
abstract class BlocBase{
  void dispose();
}

//对StatefulWidget进行一次改造,改造其构造函数,使其内部拥有bloc实例
class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final Widget child;
  final T bloc;
  final bool usedispose;

  @override
  State<StatefulWidget> createState() {
    return new _BlocProviderState<T>();
  }

  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
    this.usedispose: true
  }):super(key: key);

  //传入BlocProvider的泛型获取内部控制器
  static T of<T extends BlocBase>(BuildContext context){
    final type = _typeOf<BlocProvider<T>>();
    // 通过从 某个widget 的 context 得到树结构来返回祖先widget,目的就是获取最上层的statefullwidget
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>>{
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    if(widget.usedispose){
      widget.bloc.dispose();
    }
    super.dispose();
  }
}
