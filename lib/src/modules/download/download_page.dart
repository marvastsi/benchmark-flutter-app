import 'dart:io';

import 'package:benchmark_flutter_app/home_page.dart';
import 'package:benchmark_flutter_app/src/modules/download/dowload_client.dart';
import 'package:benchmark_flutter_app/src/modules/http/http_exception.dart';
import 'package:benchmark_flutter_app/src/modules/model/download_file.dart';
import 'package:flutter/material.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
        child: const SingleChildScrollView(child: DownloadForm()),
      ),
    );
  }
}

class DownloadForm extends StatefulWidget {
  const DownloadForm({super.key});

  @override
  State<DownloadForm> createState() => _DownloadFormState();
}

class _DownloadFormState extends State<DownloadForm> {
  final _formKey = GlobalKey<FormState>();
  final formValidVN = ValueNotifier<bool>(false);
  final _fileNameController = TextEditingController();
  Future<DownloadFile>? _futureResponse;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _fileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: () {
        formValidVN.value = _formKey.currentState?.validate() ?? false;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4.0),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Not a valid username';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'File',
                hintText: 'File to Download',
              ),
              controller: _fileNameController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, top: 100, right: 50),
            child: ValueListenableBuilder<bool>(
                valueListenable: formValidVN,
                builder: (_, formValid, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: !formValid
                          ? null
                          : () {
                              setState(() {
                                _futureResponse = download(
                                    fileName: _fileNameController.text);
                              });

                              sleep(const Duration(seconds: 2));

                              showSuccessMessage();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: navigate(context, 1)),
                              );
                            },
                      child: const Text('Download'),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  void showSuccessMessage() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: buildFutureBuilder()),
    );
  }

  FutureBuilder<DownloadFile> buildFutureBuilder() {
    return FutureBuilder<DownloadFile>(
      future: _futureResponse,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text('${snapshot.data}');
        } else if (snapshot.hasError) {
          HttpException error = snapshot.error! as HttpException;
          return Text('${error.code}: ${error.message}');
        }

        return const CircularProgressIndicator();
      },
    );
  }

  WidgetBuilder navigate(BuildContext context, int page) {
    if (page == 1) {
      return (context) => const HomePage();
    }
    throw Exception('No routes found');
  }
}
