import 'package:benchmark_flutter_app/src/modules/account/account_page.dart';
import 'package:benchmark_flutter_app/src/modules/config/config_page.dart';
import 'package:benchmark_flutter_app/src/modules/download/download_page.dart';
import 'package:benchmark_flutter_app/src/modules/login/login_page.dart';
import 'package:benchmark_flutter_app/src/modules/media/media_player_page.dart';
import 'package:benchmark_flutter_app/src/modules/model/config.dart';
import 'package:benchmark_flutter_app/src/modules/upload/upload_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Config config = _createConfig();
    return MaterialApp(
      title: 'Green Benchmark',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const AppConfigPage(),
      // home: LoginPage(config: config),
      // home: AccountPage(config: config),
      // home: UploadPage(config: config),
      // home: DownloadPage(config: config),
      // home: MediaPlayerPage(config: config),
    );
  }

  Config _createConfig() {
    var mediaUri =
        '/data/user/0/br.edu.utfpr.marvas.benchmark_flutter_app/cache/file_picker/video.mp4';
    var uploadUri =
        '/data/user/0/br.edu.utfpr.marvas.benchmark_flutter_app/cache/file_picker/image-file.png';
    var testLoad = 12;
    var downloadUri = 'image-file.png';
    var serverUrl = 'http://192.168.100.115:3000/api';
    var specificScenario = 0;
    return Config(testLoad, mediaUri, uploadUri, downloadUri, serverUrl,
        specificScenario);
  }
}
