// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      isUser: json['isUser'] as bool,
      name: json['name'] as String,
      email: json['email'] as String,
      message: json['message'] as String,
      messageID: json['messageID'] as String?,
    )
      ..isSensible = json['isSensible'] as bool
      ..isSpecific = json['isSpecific'] as bool
      ..isInteresting = json['isInteresting'] as bool
      ..isDangerous = json['isDangerous'] as bool;

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'isUser': instance.isUser,
      'name': instance.name,
      'message': instance.message,
      'email': instance.email,
      'messageID': instance.messageID,
      'isSensible': instance.isSensible,
      'isSpecific': instance.isSpecific,
      'isInteresting': instance.isInteresting,
      'isDangerous': instance.isDangerous,
    };
