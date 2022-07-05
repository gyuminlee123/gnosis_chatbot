import 'package:json_annotation/json_annotation.dart';

part 'character.g.dart';

@JsonSerializable()

//AI 케릭터의 정보를 담는 클래스
class Character {
  const Character({
    required this.character_id,
    required this.name,
    required this.description,
    required this.imageurl});

  final String character_id;
  final String name;
  final String description;
  final String imageurl;

  /// map에서 새로운 User 인스턴스를 생성하기 위해 필요한 팩토리 생성자입니다.
  /// 생성된 `_$UserFromJson()` 생성자에게 map을 전달해줍니다.
  /// 생성자의 이름은 클래스의 이름을 따릅니다. 본 예제의 경우 User를 따릅니다.
  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);

  /// `toJson`은 클래스가 JSON 인코딩의 지원을 선언하는 규칙입니다.
  /// 이의 구현은 생성된 private 헬퍼 메서드 `_$UserToJson`을 단순히 호출합니다.
  Map<String, dynamic> toJson() => _$CharacterToJson(this);

}