part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

//초기화
class ChatInit extends ChatEvent {
  const ChatInit();
}

//서버에 message를 전송한다.
class ChatSendMsg extends ChatEvent {
  const ChatSendMsg({required this.message});
  final String message;
}

//현재 대화창의 대화들을 초기화 시킨다. ( 서버에서도 )
class ChatDeleteAll extends ChatEvent {
  const ChatDeleteAll();
}


