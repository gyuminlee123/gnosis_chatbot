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

//선택된 index의 평가를 전송한다. 전부 false면 전송할 필요 없다.
class ChatSendAssess extends ChatEvent {
  const ChatSendAssess({required this.index});
  final int index;
}


