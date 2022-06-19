import 'package:shared_preferences/shared_preferences.dart';

class ChatRepository {
  ChatRepository({required SharedPreferences plugin,}) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;
  final String keyName = '_username_';
  final String keyEmail = '_email_';
  String _username = '';
  String _email = '';

  //직전에 사용된 username, email 값을 얻어온다.
  void _init() {
    _username = _plugin.getString(keyName) ?? '';
    _email = _plugin.getString(keyEmail) ?? '';
  }

  //현재 username, email 값을 기록한다.
  Future<void> saveLogInfo(username, email) async {
    await _plugin.setString(keyName, username);
    await _plugin.setString(keyEmail, email);
  }
  //직전 사용한 username을 읽어온다.
  String loadUsername() {
    return _username;
  }

  //직전 사용한 email 을 읽어온다.
  String loadEmail() {
    return _email;
  }

}