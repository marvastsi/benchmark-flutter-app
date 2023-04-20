import 'package:benchmark_flutter_app/src/commons/config_storage.dart';
import 'package:benchmark_flutter_app/src/modules/account/account_page.dart';
import 'package:benchmark_flutter_app/src/modules/config/config_page.dart';
import 'package:benchmark_flutter_app/src/modules/download/download_page.dart';
import 'package:benchmark_flutter_app/src/modules/execution/executions.dart';
import 'package:benchmark_flutter_app/src/modules/login/login_page.dart';
import 'package:benchmark_flutter_app/src/modules/media/media_player_page.dart';
import 'package:benchmark_flutter_app/src/modules/model/config.dart';
import 'package:benchmark_flutter_app/src/modules/upload/upload_page.dart';
import 'package:flutter/material.dart';

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
        width: double.infinity,
        height: double.infinity,
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
  late Function(BuildContext) btnPressed;
  late Config _config;

  @override
  void initState() {
    refreshData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('> ExecutionForm.build');
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
                btnPressed(context);
              },
              child: Text(_textButton),
            ),
          ),
        ),
      ],
    );
  }

  void refreshData() {
    print('> ExecutionForm.refreshData');
    ConfigStorage().getConfig().then((config) {
      print('> ExecutionForm.refreshData.getConfig');
      setState(() {
        print('> ExecutionForm.refreshData.getConfig.setState');
        _config = config;
        testExecution = TestExecution.getInstance(config: _config);

        if (testExecution.hasNext()) {
          print('> ExecutionForm.refreshData.if=>testExecution.hasNext');
          _scenario = testExecution.next();
          print('> ExecutionForm.refreshData._scenario => $_scenario');
          if (testExecution.isRunning()) {
            _textLabel = 'Test Execution is Running';
          }
          btnPressed = (ctx) {
            if (!testExecution.isRunning()) {
              testExecution.start();
            }

            _executeScenario(ctx);
          };
        } else {
          _textLabel = 'Test Execution Finished!';
          _textButton = 'Reconfigure';
          _scenario = 0;
          testExecution.stop();
          btnPressed = (ctx) {
            print('>>> ExecutionForm.btnPressed-reconfigure($_scenario, ${testExecution.isRunning()})');
            _navigate(ctx);
          };
        }
        print('>>> ExecutionForm.btnPressed($_scenario, ${testExecution.isRunning()})');
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _executeScenario(context));
      });
    });
  }

  void _onGoBack(dynamic value) {
    print('>>> ExecutionForm._onGoBack()');
    refreshData();
    setState(() {});
  }

  void _executeScenario(BuildContext context) {
    print('>>> ExecutionForm._executeScenario()');
    if (testExecution.isRunning()) {
      Future.delayed(const Duration(seconds: 2), () => _navigate(context));
    }
  }

  // void _navigate(BuildContext context) {
  //   print('>>> ExecutionForm._navigate()');
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: _getPageRoute(context, _scenario)),
  //   ).then((_) => setState(() {}));
  // }
  void _navigate(BuildContext context) {
    print('>>> ExecutionForm._navigate()');
    Route route = MaterialPageRoute(builder: _getPageRoute(context, _scenario));
    Navigator.push(context, route).then(_onGoBack);
  }

  WidgetBuilder _getPageRoute(BuildContext context, int page) {
    print('> ExecutionForm._getPageRoute(page => $page)');
    switch (page) {
      case 0:
        return (context) => const AppConfigPage();
      case 1:
        return (context) => LoginPage(config: _config);
      case 2:
        return (context) => AccountPage(config: _config);
      case 3:
        return (context) => DownloadPage(config: _config);
      case 4:
        return (context) => UploadPage(config: _config);
      case 5:
        return (context) => MediaPlayerPage(config: _config);
    }
    throw Exception('No routes found');
  }
}
