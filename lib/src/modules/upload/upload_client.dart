import 'dart:async';
import 'dart:convert';

import 'package:benchmark_flutter_app/src/modules/http/http_exception.dart';
import 'package:benchmark_flutter_app/src/modules/model/login.dart';
import 'package:benchmark_flutter_app/src/modules/model/upload_file.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';


UploadFile parseResponse(String responseBody) =>
    UploadFile.fromJson(jsonDecode(responseBody));

Future<UploadFile> upload({required String fileName}) async {

  print(fileName);
  var url = Uri.parse('http://192.168.100.115:3000/api/files/upload');
  print(url);

  final response = await http.get(
      url,
      headers: createDefaultHeader()
  ).catchError((err) {
    print('Error: $err');
    return Response('', 500, reasonPhrase: 'Client exception: $err');
  });

  if (response.statusCode == 200) {
    print({response.statusCode, '${response.reasonPhrase}', response.body});
    return compute(parseResponse, response.body);
  } else {
    print({response.statusCode, '${response.reasonPhrase}'});
    throw HttpException(response.statusCode, '${response.reasonPhrase}');
  }
}

Map<String, String> createDefaultHeader(
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

