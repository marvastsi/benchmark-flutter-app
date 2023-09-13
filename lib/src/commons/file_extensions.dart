import 'dart:io';

extension FileExtention on FileSystemEntity {
  String get name => uri.pathSegments.last;
}
