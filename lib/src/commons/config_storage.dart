import 'package:benchmark_flutter_app/src/modules/model/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

void saveConfig(Config config) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setInt('testLoad', config.testLoad);
  await prefs.setString('mediaUri', config.mediaUri);
  await prefs.setString('uploadUri', config.uploadUri);
  await prefs.setString('downloadUri', config.downloadUri);
  await prefs.setString('serverUrl', config.serverUrl);
  await prefs.setInt('specificScenario', config.specificScenario);
}

Future<Config> getConfig() async {
  final prefs = await SharedPreferences.getInstance();

  final testLoad = prefs.getInt('testLoad') ?? 100;
  final mediaUri = prefs.getString('mediaUri') ?? '';
  final uploadUri = prefs.getString('uploadUri') ?? '';
  final downloadUri = prefs.getString('downloadUri') ?? '';
  final serverUrl = prefs.getString('serverUrl') ?? '';
  final specificScenario = prefs.getInt('specificScenario') ?? 0;

  return Config(
      testLoad, mediaUri, uploadUri, downloadUri, serverUrl, specificScenario);
}
