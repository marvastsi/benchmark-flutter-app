class HttpException implements Exception {
  final String message;
  final int code;

  HttpException(this.code, this.message);
}