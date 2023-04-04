import 'package:benchmark_flutter_app/src/modules/model/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CredentialStorage {
  static const apiToken = 'API_TOKEN';

  void saveToken(Token token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(apiToken, token.value);
  }

  Future<Token> getConfig() async {
    final prefs = await SharedPreferences.getInstance();

    final value = prefs.getString(apiToken) ?? '';

    return Token(value: value);
  }

  void deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(apiToken);
  }
}
