import 'dart:io';

import 'package:benchmark_flutter_app/src/commons/file_extensions.dart';
import 'package:benchmark_flutter_app/src/modules/http/http_exception.dart';
import 'package:benchmark_flutter_app/src/modules/model/config.dart';
import 'package:benchmark_flutter_app/src/modules/model/upload_file.dart';
import 'package:benchmark_flutter_app/src/modules/upload/upload_client.dart';
import 'package:flutter/material.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key, required this.config});

  final Config config;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey<String>('upload_page'),
      appBar: AppBar(
        title: const Text('Upload'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
        child: SingleChildScrollView(
            child: UploadForm(
                baseUrl: config.serverUrl, uploadUri: config.uploadUri)),
      ),
    );
  }
}

class UploadForm extends StatefulWidget {
  const UploadForm({super.key, required this.baseUrl, required this.uploadUri});

  final String baseUrl;
  final String uploadUri;

  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  final _formKey = GlobalKey<FormState>();
  final formValidVN = ValueNotifier<bool>(false);
  final _filePathController = TextEditingController();
  Future<UploadFile>? _futureResponse;
  late Function(BuildContext) btnPressed;

  @override
  void initState() {
    super.initState();

    setState(() {
      var file = File.fromUri(Uri.file(widget.uploadUri));
      _filePathController.text = file.name;

      btnPressed = (ctx) {
        setState(() {
          _futureResponse =
              UploadClient(baseUrl: widget.baseUrl).upload(file: file);
        });

        _showSuccessMessage();

        Future.delayed(
            const Duration(seconds: 2), () => Navigator.pop(context));
      };

      WidgetsBinding.instance.addPostFrameCallback((_) => btnPressed(context));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _filePathController.dispose();
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
                labelText: 'File path',
                hintText: 'File to Upload',
              ),
              controller: _filePathController,
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
                      onPressed: !formValid ? null : btnPressed(context),
                      child: const Text('Upload'),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: _buildFutureBuilder()),
    );
  }

  FutureBuilder<UploadFile> _buildFutureBuilder() {
    return FutureBuilder<UploadFile>(
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
}
