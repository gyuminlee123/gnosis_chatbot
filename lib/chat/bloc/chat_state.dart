part of 'chat_bloc.dart';

//Chatstatus 의 정의
//init : 채팅방 초기화에 필요한 정보를 읽어온다. username,email,botname,messageList
//       다 준비가 되면 입력 받을 수 있는 ready 상태가 된다.
//ready : 사용자로 부터 message를 입력받는다.
//fetching : 사용자가 입력한 message에 대한 bot의 대답을 가져오는 상태
//assess : bot의 대답에 대한 평가를 사용자가 입력하는 상태


enum ChatStatus { init, ready, deleteall, fetching, assess }

class ChatState extends Equatable {
  ChatState({
    this.status = ChatStatus.init,
    this.username = '',
    this.email = '',
    this.botname = '',
    this.messageList = const <Message> [],
  }) {}

  final ChatStatus status;
  final String username;
  final String email;
  final String botname;
  List<Message> messageList;

  ChatState copyWith({
    ChatStatus? status,
    String? username,
    String? email,
    String? botname,
    List<Message>? messageList,
  }) {
    return ChatState(
      status: status ?? this.status,
      username: username ?? this.username,
      email: email ?? this.email,
      botname: botname ?? this.botname,
      messageList: messageList ?? this.messageList,
    );
  }

  @override
  List<Object> get props => [status,username,email,botname,messageList];
}
