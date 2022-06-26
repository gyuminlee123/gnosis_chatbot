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
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'isUser': instance.isUser,
      'name': instance.name,
      'message': instance.message,
      'email': instance.email,
    };
