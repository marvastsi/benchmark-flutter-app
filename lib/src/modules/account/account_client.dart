import 'dart:async';
import 'dart:convert';

import 'package:benchmark_flutter_app/src/commons/http_response_extensions.dart';
import 'package:benchmark_flutter_app/src/modules/http/http_exception.dart';
import 'package:benchmark_flutter_app/src/modules/model/account.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

Account parseResponse(String responseBody) =>
    Account.fromJson(jsonDecode(responseBody));

Future<Account> saveAccount(Account account) async {
  print(account);
  var url = Uri.parse('http://192.168.100.115:3000/api/accounts');
  print(url);

  var jsonBody = jsonEncode(account);
  print(jsonBody);

  final response = await http
      .post(url, headers: createDefaultHeader(), body: jsonBody)
      .catchError((err) {
    print('Error: $err');
    return Response('', 500, reasonPhrase: 'Client exception: $err');
  });

  if (response.isSuccessful) {
    print({response.statusCode, '${response.reasonPhrase}', response.body});
    return compute(parseResponse, response.body);
  } else {
    print({response.statusCode, '${response.reasonPhrase}'});
    throw HttpException(response.statusCode, '${response.reasonPhrase}');
  }
}

Map<String, String> createDefaultHeader(
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
