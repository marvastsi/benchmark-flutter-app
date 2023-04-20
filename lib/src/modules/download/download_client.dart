import 'dart:async';
import 'dart:io';

import 'package:benchmark_flutter_app/src/commons/http_response_extensions.dart';
import 'package:benchmark_flutter_app/src/modules/http/http_exception.dart';
import 'package:benchmark_flutter_app/src/modules/model/download_file.dart';
import 'package:external_path/external_path.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class DownloadClient {
  const DownloadClient({required this.baseUrl});

  final String baseUrl;

  Future<DownloadFile> download({required String fileName}) async {
    print(fileName);
    var url = Uri.parse('$baseUrl/files/download/$fileName');
    print(url);

    final response =
        await http.get(url, headers: _createDefaultHeader()).catchError((err) {
      print('Error: $err');
      return Response('', 500, reasonPhrase: 'Client exception: $err');
    });

    if (response.isSuccessful) {
      String path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      try {
        Directory dir = Directory(path);
        var file = File('${dir.path}/$fileName');
        if (file.existsSync()) {
          file.deleteSync();
        }
        var ios = file.openWrite(mode: FileMode.append);
        ios.add(response.bodyBytes);
        ios.flush();
        print({response.statusCode, '${response.reasonPhrase}'});
        return DownloadFile(file);
      } on Exception catch (ex) {
        print('Error: $ex');
        rethrow;
      }
    } else {
      print({response.statusCode, '${response.reasonPhrase}'});
      throw HttpException(response.statusCode, '${response.reasonPhrase}');
    }
  }

  Map<String, String> _createDefaultHeader(
      {String authorization = '',
      String accept = 'multipart-file',
      String contentType = 'application/json; charset=UTF-8'}) {
    return {
      'Accept': accept,
      'Content-Type': contentType,
      'Authorization': authorization,
      'Connection': 'Keep-Alive',
    };
  }
}
