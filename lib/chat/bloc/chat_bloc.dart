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
    emit(state.copyWith(
      status: ChatStatus.ready,
      username: _chatRepository.loadUsername(),
      email: _chatRepository.loadEmail(),
      botname: _chatRepository.loadBotname(),
    ));
  }

  void _onChatSendMsg(ChatSendMsg event, Emitter<ChatState> emit) {}
}
