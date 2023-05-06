import 'package:benchmark_flutter_app/src/modules/download/download_client.dart';
import 'package:benchmark_flutter_app/src/modules/http/http_exception.dart';
import 'package:benchmark_flutter_app/src/modules/model/config.dart';
import 'package:benchmark_flutter_app/src/modules/model/download_file.dart';
import 'package:flutter/material.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({super.key, required this.config});

  final Config config;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey<String>('download_page'),
      appBar: AppBar(
        title: const Text('Download'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(top: 40, right: 30, left: 30),
        child: SingleChildScrollView(
            child: DownloadForm(
                baseUrl: config.serverUrl, downloadUri: config.downloadUri)),
      ),
    );
  }
}

class DownloadForm extends StatefulWidget {
  const DownloadForm(
      {super.key, required this.baseUrl, required this.downloadUri});

  final String baseUrl;
  final String downloadUri;

  @override
  State<DownloadForm> createState() => _DownloadFormState();
}

class _DownloadFormState extends State<DownloadForm> {
  final _formKey = GlobalKey<FormState>();
  final formValidVN = ValueNotifier<bool>(false);
  final _fileNameController = TextEditingController();
  Future<DownloadFile>? _futureResponse;
  late Function(BuildContext) btnPressed;

  @override
  void initState() {
    super.initState();

    setState(() {
      _fileNameController.text = widget.downloadUri;

      btnPressed = (ctx) {
        setState(() {
          _futureResponse = DownloadClient(baseUrl: widget.baseUrl)
              .download(fileName: _fileNameController.text);
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
    _fileNameController.dispose();
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
                  return 'Not a valid file';
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
                      onPressed: !formValid ? null : btnPressed(context),
                      child: const Text('Download'),
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

  FutureBuilder<DownloadFile> _buildFutureBuilder() {
    return FutureBuilder<DownloadFile>(
      future: _futureResponse,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text('Download Executed: ${snapshot.data?.file}');
        } else if (snapshot.hasError) {
          Exception error = snapshot.error! as Exception;
          var message = 'Download failed';
          if (error is HttpException) {
            message = '${error.code}: $message';
          }
          return Text(message);
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
