//Json serialize를 사용한다.
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()

//채팅 메세지를 저장하는 Class
class Message {
  Message({
    required this.isUser,
    required this.name,
    this.email,
    required this.time,
    required this.message,
  });

  final bool isUser;
  final String name;
  final DateTime time;
  final String message;
  String? email = '';

  /// map에서 새로운 User 인스턴스를 생성하기 위해 필요한 팩토리 생성자입니다.
  /// 생성된 `_$UserFromJson()` 생성자에게 map을 전달해줍니다.
  /// 생성자의 이름은 클래스의 이름을 따릅니다. 본 예제의 경우 User를 따릅니다.
  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  /// `toJson`은 클래스가 JSON 인코딩의 지원을 선언하는 규칙입니다.
  /// 이의 구현은 생성된 private 헬퍼 메서드 `_$UserToJson`을 단순히 호출합니다.
  Map<String, dynamic> toJson() => _$MessageToJson(this);

}