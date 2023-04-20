import 'dart:math';

import 'package:benchmark_flutter_app/src/modules/model/config.dart';

abstract class IExecution {
  bool hasNext();

  int next();

  bool isRunning();

  void start();

  void stop();
}

class TestExecution implements IExecution {
  final Config config;
  final List<int> executions;
  int _index = 0;
  bool _running = false;

  TestExecution({required this.config, required this.executions});

  static IExecution? _instance;

  static IExecution getInstance({required Config config}) {
    return _instance ??= TestExecution(
        config: config,
        executions:
            RandomList().create(config.testLoad, config.specificScenario));
  }

  @override
  bool hasNext() {
    return _index < config.testLoad;
  }

  @override
  bool isRunning() => _running;

  @override
  int next() {
    return executions[_index++];
  }

  @override
  void start() {
    _running = true;
  }

  @override
  void stop() {
    _running = false;
    _instance = null;
  }
}

class RandomList {
  List<int> create(int length, int specificScenario) {
    if (specificScenario == 0) {
      const int first = 1;
      const int last = 5;
      var list = List.generate(length, (_) => _rand(first, last));
      print('>> list: $list');
      return list;
    } else {
      var list = List.generate(length, (_) => specificScenario);
      print('>> list: $list');
      return list;
    }
  }

  int _rand(int first, int last) {
    return first + Random().nextInt((last + 1) - first);
  }
}
