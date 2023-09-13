import 'package:http/http.dart';

extension HttpResponseExtention on Response {
  bool get isSuccessful => statusCode >= 200 && statusCode <= 207;
}
