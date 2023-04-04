import 'package:benchmark_flutter_app/home_page.dart';
import 'package:benchmark_flutter_app/src/commons/config_storage.dart';
import 'package:benchmark_flutter_app/src/modules/execution/executions.dart';
import 'package:flutter/material.dart';

import '../config/config_page.dart';

class ExecutionPage extends StatelessWidget {
  const ExecutionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Green Benchmark'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
        child: const SingleChildScrollView(child: ExecutionForm()),
      ),
    );
  }
}

class ExecutionForm extends StatefulWidget {
  const ExecutionForm({super.key});

  @override
  State<ExecutionForm> createState() => _ExecutionFormState();
}

class _ExecutionFormState extends State<ExecutionForm> {
  late int _scenario;
  String _textLabel = 'Click the button to Start';
  String _textButton = 'Start';
  late IExecution testExecution;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
            child: Text(_textLabel),
          ),
        ),
        const SizedBox(
          height: 200,
        ),
        Center(
          child: SizedBox(
            child: ElevatedButton(
              onPressed: () {
                setState(() async {
                  final config = await ConfigStorage().getConfig();
                  testExecution = TestExecution.getInstance(config: config);
                  _scenario = testExecution.next();

                  if (testExecution.hasNext()) {
                    _scenario = testExecution.next();
                    if (!testExecution.isRunning()) {
                      testExecution.start();
                    }
                    _textLabel = 'Test Execution is Running';
                  } else {
                    _textLabel = 'Test Execution Finished!';
                    _textButton = 'Reconfigure';
                    _scenario = 0;
                    testExecution.stop();
                  }

                });

                // Apos o build do Widget chamar a função de onPressed()
                // assim onPressed vai executar de acordo com o que foi configurado
                // configurar duas funções diferentes para o onPressed
                if (testExecution.isRunning()) {
                  navigate(context);
                }
              },
              child: Text(_textButton),
            ),
          ),
        ),
      ],
    );
  }

  void navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: getPageRoute(context, _scenario)),
    );
  }

  WidgetBuilder getPageRoute(BuildContext context, int page) {
    switch (page) {
      case 0:
        return (context) => const AppConfigPage();
      case 1:
        return (context) => const HomePage();
      case 2:
        return (context) => const HomePage();
      case 3:
        return (context) => const HomePage();
      case 4:
        return (context) => const HomePage();
      case 5:
        return (context) => const HomePage();
    }
    throw Exception('No routes found');
  }
}
