// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
      character_id: json['character_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageurl: json['imageurl'] as String,
    );

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      'character_id': instance.character_id,
      'name': instance.name,
      'description': instance.description,
      'imageurl': instance.imageurl,
    };
