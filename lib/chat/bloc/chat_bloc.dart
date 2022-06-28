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
    on<ChatSendAssess>(_onChatSendAssess);
  }

  final ChatRepository _chatRepository;

  //상태를 초기화 한다.
  Future<void> _onChatInit(ChatInit event, Emitter<ChatState> emit) async{
    List<Message> newMsgList = [];
    emit(state.copyWith(
      status: ChatStatus.init,
      username: _chatRepository.loadUsername(),
      email: _chatRepository.loadEmail(),
      botname: event.botname,
      messageList: newMsgList,
    ));

    //이전 대화목록을 불러온다.
    //Server에서 불러오는 코드
    /* var answer = await _chatRepository.getPrevMsgFromServer(_chatRepository.loadEmail(), state.botname);
    List dialogList = answer['dialogs'];

    if(dialogList.isNotEmpty) {
      for (var dialog in dialogList) {
            var newMsg1 = Message(isUser:true, name: state.username, email: state.email, message: dialog['user_input']);
            newMsgList.insert(0,newMsg1);
            var newMsg2 = Message(isUser:false, name: state.botname, email: '', message: dialog['response'], messageID: dialog['dialog_id']);
            newMsgList.insert(0,newMsg2);
      }
    }*/

    //Local 에서 이전 대화목록을 불러온다.
    String msgListString = await _chatRepository.getPrevMsgFromLocal(state.botname, state.email);

    if(msgListString.isNotEmpty) {
      var jsonResult = jsonDecode(msgListString);
      for( var newMessage in jsonResult ) {
        Message msg = Message.fromJson(newMessage);
        newMsgList.add(msg);
      }
    }

    emit(state.copyWith(
      status: ChatStatus.ready,
      username: _chatRepository.loadUsername(),
      email: _chatRepository.loadEmail(),
      botname: event.botname,
      messageList: newMsgList,
    ));
  }

  //Server로 message를 보내고 응답을 받는다.
  Future<void> _onChatSendMsg(ChatSendMsg event, Emitter<ChatState> emit) async{
    emit(state.copyWith(
      status: ChatStatus.fetching,
    ));
    var answer = await _chatRepository.sendMsgToServer(state.username, state.email, state.botname, event.message);
    var newMessage = Message(
        isUser: false,
        name: state.botname,
        email: '',
        message: answer['response'],
        messageID: answer['dialog_id']);
    state.messageList.insert(0,newMessage);
    //주고받은 메세지를 로컬에도 저장해야한다.
    var msgListString = jsonEncode(state.messageList).toString();
    _chatRepository.saveMsgListToLocal(state.botname, state.email, msgListString);

    //print('msgListString : ${msgListString}');

    emit(state.copyWith(
      status: ChatStatus.ready,
      messageList: state.messageList
    ));
  }

  //Server로 평가내용을 보낸다.
  Future<void> _onChatSendAssess(ChatSendAssess event, Emitter<ChatState> emit) async {
    emit(state.copyWith(
      status: ChatStatus.assess,
    ));
    var answer = await _chatRepository.sendAssess(
        state.messageList[event.index].messageID,
        state.email, //AI의 Message정보에는 email(사용자ID) 가 ''로 되어있으므로 현재 state에서 유지하는 email값을 준다.
        state.messageList[event.index].isSensible,
        state.messageList[event.index].isSpecific,
        state.messageList[event.index].isInteresting,
        state.messageList[event.index].isDangerous
    );
    //평가한 것을 로컬에도 저장해야한다.
    var msgListString = jsonEncode(state.messageList).toString();
    _chatRepository.saveMsgListToLocal(state.botname, state.email, msgListString);

    emit(state.copyWith(
      status: ChatStatus.ready,
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
      //로컬저장소에서도 지운다.
      _chatRepository.deleteMsgListInLocal(state.botname, state.email);
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
