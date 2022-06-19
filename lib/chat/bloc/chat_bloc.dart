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
    on<ChatOnChat>(_onChatOnChat);
  }

  final ChatRepository _chatRepository;

  void _onChatInit(ChatInit event, Emitter<ChatState> emit) {
  }

  void _onChatOnChat(ChatOnChat event, Emitter<ChatState> emit) {
  }
}