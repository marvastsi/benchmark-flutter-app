import 'dart:async';
import 'dart:convert';

import 'package:benchmark_flutter_app/src/commons/http_response_extensions.dart';
import 'package:benchmark_flutter_app/src/modules/http/http_exception.dart';
import 'package:benchmark_flutter_app/src/modules/model/account.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AccountClient {
  const AccountClient({required this.baseUrl});

  final String baseUrl;

  AccountCreated _parseResponse(String responseBody) =>
      AccountCreated.fromJson(jsonDecode(responseBody));

  Future<AccountCreated> saveAccount(Account account) async {
    var url = Uri.parse('$baseUrl/accounts');

    var jsonBody = jsonEncode(account);

    final response = await http
        .post(url, headers: _createDefaultHeader(), body: jsonBody)
        .catchError((err) {
      print('Error: $err');
      return Response('', 500, reasonPhrase: 'Client exception: $err');
    });

    if (response.isSuccessful) {
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
