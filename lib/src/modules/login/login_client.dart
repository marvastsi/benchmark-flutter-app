import 'dart:async';
import 'dart:convert';

import 'package:benchmark_flutter_app/src/commons/http_response_extensions.dart';
import 'package:benchmark_flutter_app/src/modules/http/http_exception.dart';
import 'package:benchmark_flutter_app/src/modules/model/login.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class LoginClient {
  const LoginClient({required this.baseUrl});

  final String baseUrl;

  Token _parseResponse(String responseBody) =>
      Token.fromJson(jsonDecode(responseBody));

  Future<Token> login(Credentials credentials) async {
    print(credentials);
    var url = Uri.parse('$baseUrl/login');
    print(url);

    var jsonBody = jsonEncode(credentials);
    print(jsonBody);

    final response = await http
        .post(url, headers: _createDefaultHeader(), body: jsonBody)
        .catchError((err) {
      print('Error: $err');
      return Response('', 500, reasonPhrase: 'Client exception: $err');
    });

    if (response.isSuccessful) {
      print({response.statusCode, '${response.reasonPhrase}', response.body});
      return compute(_parseResponse, response.body);
    } else {
      print({response.statusCode, '${response.reasonPhrase}'});
      throw HttpException(response.statusCode, '${response.reasonPhrase}');
    }
  }

  Map<String, String> _createDefaultHeader(
      {String authorization = '',
      String accept = 'application/json',
      String contentType = 'application/json; charset=UTF-8'}) {
    return {
      'Accept': accept,
      'Content-Type': contentType,
      'Authorization': authorization,
      'Connection': 'Keep-Alive',
    };
  }
}
