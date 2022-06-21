import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:gnosis_chatbot/repository/chatRepository.dart';
import 'package:gnosis_chatbot/model/message.dart';

part 'chat_state.dart';

part 'chat_event.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required ChatRepository chatRepository,
  })  : _chatRepository = chatRepository,
        super(ChatState()) {
    on<ChatInit>(_onChatInit);
    on<ChatSendMsg>(_onChatSendMsg);
  }

  final ChatRepository _chatRepository;

  void _onChatInit(ChatInit event, Emitter<ChatState> emit) {
    List<Message> newMsgList = [];

    emit(state.copyWith(
      status: ChatStatus.ready,
      username: _chatRepository.loadUsername(),
      email: _chatRepository.loadEmail(),
      botname: _chatRepository.loadBotname(),
      messageList: newMsgList,
    ));
  }

  Future<void> _onChatSendMsg(ChatSendMsg event, Emitter<ChatState> emit) async{
    emit(state.copyWith(
      status: ChatStatus.fetching,
    ));
    var answer = await _chatRepository.sendMsgToServer(state.username, state.email, event.message);
    var newMessage = Message(isUser: false, name: state.botname, time: DateTime.now(), message: answer);
    print('length: ${state.messageList.length}');
    state.messageList.insert(0,newMessage);
    print('length: ${state.messageList.length}');
    emit(state.copyWith(
      status: ChatStatus.ready,
      messageList: state.messageList
    ));
    print('length: ${state.messageList.length}');
  }
}
