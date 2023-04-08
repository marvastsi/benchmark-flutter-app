// import 'dart:async';
// import 'dart:io';
//
// import 'package:benchmark_flutter_app/src/modules/http/http_exception.dart';
// import 'package:benchmark_flutter_app/src/modules/model/download_file.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/http.dart';
//
// Future<DownloadFile> download({required String fileName}) async {
//   print(fileName);
//   var url =
//       Uri.parse('http://192.168.100.115:3000/api/files/download/$fileName');
//   print(url);
//
//   final response =
//       await http.get(url, headers: createDefaultHeader()).catchError((err) {
//     print('Error: $err');
//     return Response('', 500, reasonPhrase: 'Client exception: $err');
//   });
//
//   if (response.statusCode == 200) {
//     // getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
//     try {
//       Directory dir = Directory('/storage/emulated/0/Download');
//       var file = File('${dir.path}/$fileName');
//       // if (file.existsSync()) {
//       //   file.deleteSync();
//       // }
//       var ios = file.openWrite(mode: FileMode.append);
//       ios.add(response.bodyBytes);
//       ios.flush();
//       print({response.statusCode, '${response.reasonPhrase}', response.body});
//       return DownloadFile(file);
//     } on PathNotFoundException catch (ex) {
//       var error = ex.toString();
//       print('Error: $error');
//     }
//     return DownloadFile(null);
//   } else {
//     print({response.statusCode, '${response.reasonPhrase}'});
//     throw HttpException(response.statusCode, '${response.reasonPhrase}');
//   }
// }
//
// Map<String, String> createDefaultHeader(
//     {String authorization = '',
//     String accept = 'multipart-file',
//     String contentType = 'application/json; charset=UTF-8'}) {
//   return {
//     'Accept': accept,
//     'Content-Type': contentType,
//     'Authorization': authorization,
//     'Connection': 'Keep-Alive',
//   };
// }
