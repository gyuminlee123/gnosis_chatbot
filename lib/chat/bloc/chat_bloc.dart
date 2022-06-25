import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'dart:convert';
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
    on<ChatDeleteAll>(_onChatDeleteAll);
  }

  final ChatRepository _chatRepository;

  //상태를 초기화 한다.
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

  //Server로 message를 보내고 응답을 받는다.
  Future<void> _onChatSendMsg(ChatSendMsg event, Emitter<ChatState> emit) async{
    emit(state.copyWith(
      status: ChatStatus.fetching,
    ));
    var answer = await _chatRepository.sendMsgToServer(state.username, state.email, event.message);
    var newMessage = Message(
        isUser: false,
        name: state.botname,
        time: DateTime.now(),
        message: answer['response'],
        messageID: answer['dialog_id']);
    state.messageList.insert(0,newMessage);
    emit(state.copyWith(
      status: ChatStatus.ready,
      messageList: state.messageList
    ));
  }

  //API server에 대화내용 삭제를 요청
  Future<void> _onChatDeleteAll(ChatDeleteAll event, Emitter<ChatState> emit) async{
    emit(state.copyWith(
      status: ChatStatus.deleteall,
    ));

    bool isSuccess = await _chatRepository.requestDelete(state.email, state.botname);
    if( isSuccess ) {
      state.messageList.clear();
    }
    else {
      print('Fail to delete messages on server.');
    }

    emit(state.copyWith(
        status: ChatStatus.ready,
        messageList: state.messageList
    ));
  }
}
