part of 'chat_bloc.dart';

enum ChatStatus { init, onchat  }

class ChatState extends Equatable {
  ChatState({
    this.status = ChatStatus.init,
    this.username = '',
    this.email = '',
    this.botname = 'PROTO_TYPE',
    this.messageList = const <Message> [],
  }) {
    Message a = Message(isUser:true, name:'kekule', email: 'kekule@naver.com', time: DateTime.now(), message: '1');
    Message b = Message(isUser:false, name:'AI BOT', email: '', time: DateTime.now(), message: '2');
    Message c = Message(isUser:true, name:'kekule', email: 'kekule@naver.com', time: DateTime.now(), message: '3.');
    Message d = Message(isUser:false, name:'AI BOT', email: '', time: DateTime.now(), message: '4');
    Message e = Message(isUser:true, name:'kekule', email: 'kekule@naver.com', time: DateTime.now(), message: '5');
    Message f = Message(isUser:false, name:'AI BOT', email: '', time: DateTime.now(), message: '6');
    messageList = [a,b,c,d,e,f];
  }

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
