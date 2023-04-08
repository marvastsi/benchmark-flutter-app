import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:benchmark_flutter_app/src/commons/file_extensions.dart';
import 'package:benchmark_flutter_app/src/commons/http_response_extensions.dart';
import 'package:benchmark_flutter_app/src/modules/http/http_exception.dart';
import 'package:benchmark_flutter_app/src/modules/model/upload_file.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

UploadFile parseResponse(String responseBody) =>
    UploadFile.fromJson(jsonDecode(responseBody));

Future<UploadFile> upload({required File file}) async {
  var uri = Uri.parse('http://192.168.100.115:3000/api/files/upload');
  print(uri);
  var request = http.MultipartRequest('POST', uri)
    ..files.add(http.MultipartFile.fromBytes(
      'file',
      file.readAsBytesSync(),
      filename: file.name,
    ));

  var streamedResponse = await request.send().catchError((err) {
    print('Error: $err');
    return http.StreamedResponse(const Stream.empty(), 500,
        reasonPhrase: 'Client exception: $err');
  });



  final response = await http.Response.fromStream(streamedResponse);
  if (response.isSuccessful) {
    print({response.statusCode, '${response.reasonPhrase}', response.body});
    return compute(parseResponse, response.body);
  } else {
    print({response.statusCode, '${response.reasonPhrase}'});
    throw HttpException(response.statusCode, '${response.reasonPhrase}');
  }
}

