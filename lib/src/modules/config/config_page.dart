import 'dart:io';

import 'package:benchmark_flutter_app/src/commons/config_storage.dart';
import 'package:benchmark_flutter_app/src/commons/file_extensions.dart';
import 'package:benchmark_flutter_app/src/commons/permissions.dart';
import 'package:benchmark_flutter_app/src/modules/execution/execution_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/config.dart';

class AppConfigPage extends StatelessWidget {
  const AppConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey<String>('config_page'),
      appBar: AppBar(
        title: const Text('App Config'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(top: 40, right: 30, left: 30),
        child: const SingleChildScrollView(child: AppConfigForm()),
      ),
    );
  }
}

class AppConfigForm extends StatefulWidget {
  const AppConfigForm({super.key});

  @override
  State<AppConfigForm> createState() => _AppConfigFormState();
}

class _AppConfigFormState extends State<AppConfigForm> {
  final _formKey = GlobalKey<FormState>();
  final formValidVN = ValueNotifier<bool>(false);
  final _nExecutionsController = TextEditingController();
  final _uploadFileController = TextEditingController();
  final _downloadFileController = TextEditingController();
  final _serverUrlController = TextEditingController();
  final _mediaFileController = TextEditingController();
  final _nScenarioController = TextEditingController();

  ScenarioEntry? selectedScenario = ScenarioEntry.none;
  final ConfigStorage _configStorage = ConfigStorage();
  late String _mediaPath;
  late String _uploadPath;

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  @override
  void dispose() {
    _nExecutionsController.dispose();
    _mediaFileController.dispose();
    _uploadFileController.dispose();
    _downloadFileController.dispose();
    _serverUrlController.dispose();
    _nScenarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('AppConfigForm.build()');
    final List<DropdownMenuEntry<ScenarioEntry>> scenarioEntries =
        <DropdownMenuEntry<ScenarioEntry>>[];
    for (final ScenarioEntry scenario in ScenarioEntry.values) {
      scenarioEntries.add(DropdownMenuEntry<ScenarioEntry>(
          value: scenario, label: scenario.label));
    }

    return Form(
      key: _formKey,
      onChanged: () {
        formValidVN.value = _formKey.currentState?.validate() ?? false;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (value) {
                if (value == null || value.isEmpty || int.parse(value) < 10) {
                  return 'Load must be >= 10';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Executions',
                hintText: 'Number of Executions',
              ),
              controller: _nExecutionsController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: _FileEntryRow(
              validationMsg: 'Media file is required',
              label: 'Media File',
              hint: 'Media File',
              controller: _mediaFileController,
              onPressed: () async {
                _mediaPath = (await _pickFile(FileType.video))!;
                setState(() {
                  _mediaFileController.text = File(_mediaPath).name;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: _FileEntryRow(
              validationMsg: 'Upload file is required',
              label: 'File to Upload',
              hint: 'File to Upload',
              controller: _uploadFileController,
              onPressed: () async {
                _uploadPath = (await _pickFile(FileType.any))!;
                setState(() {
                  _uploadFileController.text = File(_uploadPath).name;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Download file is required';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'File to Download',
                hintText: 'File to Download',
              ),
              controller: _downloadFileController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextFormField(
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Server URL is required';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Server url',
                hintText: 'Server url',
              ),
              controller: _serverUrlController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: DropdownMenu<ScenarioEntry>(
                    inputDecorationTheme: const InputDecorationTheme(
                        border: UnderlineInputBorder()),
                    initialSelection: ScenarioEntry.none,
                    controller: _nScenarioController,
                    dropdownMenuEntries: scenarioEntries,
                    onSelected: (ScenarioEntry? scenario) {
                      setState(() {
                        selectedScenario = scenario;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0),
            child: Text(
                'If a specific scenario was selected, then only this scenario will be executed N times, where N = numberOfExecutions'),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50, right: 40, left: 40),
            child: ValueListenableBuilder<bool>(
                valueListenable: formValidVN,
                builder: (_, formValid, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: !formValid
                          ? null
                          : () {
                              Config config = Config(
                                  int.parse(_nExecutionsController.text),
                                  _mediaPath,
                                  _uploadPath,
                                  _downloadFileController.text,
                                  _serverUrlController.text,
                                  selectedScenario!.scenario);
                              print(config);
                              _configStorage.saveConfig(config);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('App config saved')),
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: _navigate(context)),
                              );
                            },
                      child: const Text('Save Config'),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  WidgetBuilder _navigate(BuildContext context) {
    return (context) => const ExecutionPage();
  }

  Future<String?> _pickFile(FileType type) async {
    final result =
        await FilePicker.platform.pickFiles(type: type, allowMultiple: false);

    if (result == null) return null;

    return result.files.first.path;
  }
}

class _FileEntryRow extends StatelessWidget {
  const _FileEntryRow(
      {this.label,
      this.hint,
      this.validationMsg,
      this.controller,
      this.onPressed});

  final String? label;
  final String? hint;
  final String? validationMsg;
  final TextEditingController? controller;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: TextFormField(
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return validationMsg;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                enabled: false,
              ),
              controller: controller,
            ),
          ),
        ),
        Ink(
          decoration: const ShapeDecoration(
            color: Colors.teal,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
          ),
          height: 35.0,
          child: IconButton(
            alignment: Alignment.center,
            icon: const Icon(
              Icons.folder,
              size: 20,
            ),
            color: Colors.white,
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}

enum ScenarioEntry {
  none(0, 'Select a scenario'),
  login(1, 'Login API'),
  account(2, 'Account Form'),
  download(3, 'Download File'),
  upload(4, 'Upload File'),
  media(5, 'Media Execution');

  const ScenarioEntry(this.scenario, this.label);

  final int scenario;
  final String label;
}
