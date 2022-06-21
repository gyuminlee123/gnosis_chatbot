import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatRepository {
  ChatRepository({required SharedPreferences plugin,}) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;
  final String keyName = '_username_';
  final String keyEmail = '_email_';
  String _username = '';
  String _email = '';
  String _botname = '';

  //직전에 사용된 username, email 값을 얻어온다.
  void _init() {
    _username = _plugin.getString(keyName) ?? '';
    _email = _plugin.getString(keyEmail) ?? '';
    _botname = 'PROTOTYPE';
  }

  //현재 username, email 값을 기록한다.
  Future<void> saveLogInfo(username, email) async {
    await _plugin.setString(keyName, username);
    await _plugin.setString(keyEmail, email);
    _username = username;
    _email = email;
  }
  //직전 사용한 username을 읽어온다.
  String loadUsername() {
    return _username;
  }

  //직전 사용한 email 을 읽어온다.
  String loadEmail() {
    return _email;
  }

  //선택된 bot의 name을 읽어온다.
  String loadBotname() {
    return _botname;
  }

  //Server로 메세지를 보내고 응답을 받아온다.
  Future<String> sendMsgToServer(username, email, message) async {
    String answer = '';
    var url = Uri.parse('https://gnosis-api-dev.cocone-m.kr/talk/jieun');
    var response = await http.post(
      url,
      headers: <String,String> {
        'Content-Type' : 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String,String> {
        "user_id": "kekule",
        "user_name": "규민",
        "text": message
      }),
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      answer = json['response'];
    } else {
      print('Request failed with status: ${response.statusCode}.');
      answer = 'Cannot get answer from AI.';
    }

    return answer;
  }
}