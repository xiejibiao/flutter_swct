import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class IndexPageBloc extends BlocBase {

  BehaviorSubject<int> _indexPageController = BehaviorSubject<int>();
  Sink<int> get _indexPageSink => _indexPageController.sink;
  Stream<int> get indexPageStream => _indexPageController.stream;

  void thisCurrentIndex(int index) {
    _indexPageSink.add(index);
  }

  @override
  void dispose() {
    _indexPageController.close();
  }
}