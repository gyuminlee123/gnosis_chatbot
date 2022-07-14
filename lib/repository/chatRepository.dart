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
  //String _botname = '';

  //직전에 사용된 username, email 값을 얻어온다.
  void _init() {
    _username = _plugin.getString(keyName) ?? '';
    _email = _plugin.getString(keyEmail) ?? '';
    //_botname = 'jieun';
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
  //String loadBotname() {
  //  return _botname;
  //}

  //Server로 대화삭제를 요청한다.
  //Call Example
  //POST /talk-reset
  //{
  //  "user_id": "jaehoon",
  //  "character_id": "jieun"
  //}
  Future<bool> requestDelete(email, botname) async {
    bool isDelete = false;
    var url = Uri.parse('https://gnosis-api-dev.cocone-m.kr/talk-reset');
    //Server로 보낼 내용 구성
    var response = await http.post(
      url,
      headers: <String,String> {
        'Content-Type' : 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String,String> {
        "user_id": email,
        "character_id": botname,
      }),
    );

    if(response.statusCode == 200) {
      isDelete = true;
    }
    //삭제가 성공하면 true를 반환한다.
    return isDelete;
  }

  //SharedPreferences 에 message 목록을 저장한다.
  //이때 Key 는 charactername_사용자email
  Future<void> saveMsgListToLocal(String botname, String email, String msgListString) async {
    var keyString = '${botname}_${email}';
    await _plugin.setString(keyString, msgListString);
  }

  //SharedPrefrences 로 로컬에 저장된 message 목록을 불러온다.
  Future<String> getPrevMsgFromLocal(String botname, String email) async {
    var msgListString = '';
    var keyString = '${botname}_${email}';
    msgListString = _plugin.getString(keyString) ?? '';

    return msgListString;
  }

  //로컬에 저장된 message 들을 삭제한다.
  Future<void> deleteMsgListInLocal(String botname, String email) async {
    var keyString = '${botname}_${email}';
    await _plugin.remove(keyString);
  }

  //파파고 API 로 언어의 종류를 캐치한다.
  Future<String> detectLangs(String query) async {
    String langCode = 'ko';
    String _client_id = "dpptjkzef2";
    String _client_secret = "EY74ZYbGljHqcFBaLPZLvy2diVuX8ezcJayCQcNY";
    String _content_type = "application/x-www-form-urlencoded; charset=UTF-8";
    String _url = "https://naveropenapi.apigw.ntruss.com/langs/v1/dect";

    http.Response trans = await http.post(
      Uri.parse(_url),
      headers: {
        'Content-Type': _content_type,
        'X-NCP-APIGW-API-KEY-ID': _client_id,
        'X-NCP-APIGW-API-KEY': _client_secret
      },
      body: {
        'query': query,
      },
    );
    if (trans.statusCode == 200) {
      var dataJson = jsonDecode(trans.body);
      langCode = dataJson['langCode'];
    } else {
      print(trans.statusCode);
      print(trans.body);
    }
    return langCode;
  }

  //파파고 API 로 부터 번역된 결과를 가지고 온다.
  Future<String> getTranslatedMsg(String message, String source, String target) async {
    String translatedMsg = '';
    String _client_id = "dpptjkzef2";
    String _client_secret = "EY74ZYbGljHqcFBaLPZLvy2diVuX8ezcJayCQcNY";
    String _content_type = "application/x-www-form-urlencoded; charset=UTF-8";
    String _url = "https://naveropenapi.apigw.ntruss.com/nmt/v1/translation";

    http.Response trans = await http.post(
      Uri.parse(_url),
      headers: {
        'Content-Type': _content_type,
        'X-NCP-APIGW-API-KEY-ID': _client_id,
        'X-NCP-APIGW-API-KEY': _client_secret
      },
      body: {
        'source': source,//번역전 메세지의 언어 종류
        'target': target,//번역된 메세지의 언어 종류
        'text': message,
      },
    );
    if (trans.statusCode == 200) {
      var dataJson = jsonDecode(trans.body);
      var result_papago = dataJson['message']['result']['translatedText'];
      //print(result_papago);
      translatedMsg = result_papago;
    } else {
      print(trans.statusCode);
      print(trans.body);
    }
    return translatedMsg;
  }


  //Server로 메세지를 보내고 응답을 받아온다.
  Future<dynamic> sendMsgToServer(username, email, botname, message) async {
    var json_result;
    var url = Uri.parse('https://gnosis-api-dev.cocone-m.kr/talk/$botname');
    //Server로 보낼 내용 구성
    var response = await http.post(
      url,
      headers: <String,String> {
        'Content-Type' : 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String,String> {
        "user_id": email,
        "user_name": username,
        "text": message
      }),
    );
    //서버에서 response를 받으면 decode 해서 결과를 저장한다.
    if (response.statusCode == 200) {
      json_result = jsonDecode(response.body);
      print(json_result);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      json_result = jsonDecode(response.body);
    }

    return json_result;
  }

  //Server로 부터 AI 케릭터 목록을 불러온다.
  //API Specification
  //GET /character-list
  //Call Example
  //GET /character-list
  Future<dynamic> getCharList() async {
    var json_result;
    var url = Uri.parse('https://gnosis-api-dev.cocone-m.kr/character-list');
    var response = await http.get(url);

    if(response.statusCode == 200) {
      json_result = jsonDecode(response.body);
    } else {
      print(url);
      print('Request failed with status: ${response.statusCode}.');
      json_result = jsonDecode(response.body);
    }
    return json_result;
  }

  //Server로부터 대화내용을 불러온다.
  //API Specification
  //GET /talk-query/<character_id>?user_id=<user_id>&plain
  //character_id (required)
  //캐릭터 아이디
  //user_id (required)
  //사용자 아이디
  //plain (optional)
  //생략되어 있을 경우, timestamp 와 dialog_id 까지 모두 포함해서 json 형태로 리턴
  //포함되어 있을 경우, timestamp 와 dialog_id 는 빼고 대화 스크립트만 문자열로 리턴
  //Call Example
  //GET /talk-query/jieun?user_id=lee_jaehoon
  Future<dynamic> getPrevMsgFromServer(email, botname) async {
    var json_result;
    var url = Uri.parse('https://gnosis-api-dev.cocone-m.kr/talk-query/$botname?user_id=$email');
    //Server로 보낼 내용 구성
    var response = await http.get(url);
    //서버에서 response를 받으면 decode 해서 결과를 저장한다.
    if (response.statusCode == 200) {
      json_result = jsonDecode(response.body);
      //print(json_result);
    } else {
      print(url);
      print('Request failed with status: ${response.statusCode}.');
      json_result = jsonDecode(response.body);
    }
    return json_result;
  }

  //Server로 평가내용을 전송한다.
  Future<void> sendAssess(dialog_id, assessor_id, isSensible, isSpecific, isInteresting, isDangerous) async {
    var url = Uri.parse('https://gnosis-api-dev.cocone-m.kr/talk-feedback');
    //Server로 보낼 내용 구성
    var response = await http.post(
      url,
      headers: <String,String> {
        'Content-Type' : 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String,String> {
      "dialog_id": dialog_id,
      "assessor_id": assessor_id,
      "sensible": isSensible ? '1' : '0',
      "specific": isSpecific ? '1' : '0',
      "interesting": isInteresting ? '1' : '0',
      "dangerous": isDangerous ? '1' : '0'
      }),
    );

    print( jsonEncode(<String,String> {
      "dialog_id": dialog_id,
      "assessor_id": assessor_id,
      "sensible": isSensible ? '1' : '0',
      "specific": isSpecific ? '1' : '0',
      "interesting": isInteresting ? '1' : '0',
      "dangerous": isDangerous ? '1' : '0'
    }) );

    //서버에서 response를 받으면 decode 해서 결과를 저장한다.
    if (response.statusCode == 200) {
      //print(response.statusCode);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

}