import 'package:benchmark_flutter_app/src/modules/model/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigStorage {
  static const mediaUriParam = 'mediaUri';
  static const uploadUriParam = 'uploadUri';
  static const downloadUriParam = 'downloadUri';
  static const serverUrlParam = 'serverUrl';
  static const specificScenarioParam = 'specificScenario';
  static const loadParam = 'loadConfig';

  void saveConfig(Config config) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(loadParam, config.testLoad);
    await prefs.setString(mediaUriParam, config.mediaUri);
    await prefs.setString(uploadUriParam, config.uploadUri);
    await prefs.setString(downloadUriParam, config.downloadUri);
    await prefs.setString(serverUrlParam, config.serverUrl);
    await prefs.setInt(specificScenarioParam, config.specificScenario);
  }

  Future<Config> getConfig() async {
    final prefs = await SharedPreferences.getInstance();

    final testLoad = prefs.getInt(loadParam) ?? 100;
    final mediaUri = prefs.getString(mediaUriParam) ?? '';
    final uploadUri = prefs.getString(uploadUriParam) ?? '';
    final downloadUri = prefs.getString(downloadUriParam) ?? '';
    final serverUrl = prefs.getString(serverUrlParam) ?? '';
    final specificScenario = prefs.getInt(specificScenarioParam) ?? 0;

    return Config(testLoad, mediaUri, uploadUri, downloadUri, serverUrl,
        specificScenario);
  }
}
