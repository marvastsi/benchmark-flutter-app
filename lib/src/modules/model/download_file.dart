import 'dart:io';

import 'package:benchmark_flutter_app/src/commons/file_extensions.dart';

class DownloadFile {
  final File? file;

  DownloadFile(this.file);

  @override
  String toString() {
    return file?.name ?? '{file: null}';
  }
}