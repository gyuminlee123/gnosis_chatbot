part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChatInit extends ChatEvent {
  const ChatInit();
}

class ChatOnChat extends ChatEvent {
  const ChatOnChat();
}

