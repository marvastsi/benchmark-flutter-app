import 'dart:async';
import 'dart:convert';

import 'package:benchmark_flutter_app/src/commons/http_response_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

List<File> parseFiles(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<File>((json) => File.fromJson(json)).toList();
}

Future<List<File>> fetchFiles(http.Client client) async {
  final response =
      await client.get(Uri.parse('http://192.168.100.115:3000/api/files/list'));

  if (response.isSuccessful) {
    return compute(parseFiles, response.body);
  } else {
    throw Exception('Failed to load files list');
  }
}

class File {
  final String name;
  final String url;

  const File({
    required this.name,
    required this.url,
  });

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      name: json['name'],
      url: json['url'],
    );
  }
}
