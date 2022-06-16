import 'package:shared_preferences/shared_preferences.dart';

class ChatRepository {
  ChatRepository({required SharedPreferences plugin,}) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  //마지막에 사용된 username, email 값을 얻어온다.
  void _init() {
  }
}