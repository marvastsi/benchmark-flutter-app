import 'package:permission_handler/permission_handler.dart';

void requestPermission() async {
  var statusStorageExt = await Permission.manageExternalStorage.status;
  if (!statusStorageExt.isGranted) {
    Permission.manageExternalStorage.request();
  }

  var statusStorage = await Permission.storage.status;
  if (!statusStorage.isGranted) {
    Permission.storage.request();
  }
}
