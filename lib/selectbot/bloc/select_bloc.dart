import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'dart:convert';
import 'package:gnosis_chatbot/repository/chatRepository.dart';

part 'select_state.dart';

part 'select_event.dart';

class SelectBloc extends Bloc<SelectEvent, SelectState> {
  SelectBloc({
    required ChatRepository chatRepository,
  })  : _chatRepository = chatRepository,
        super(SelectState()) {
    on<SelectInit>(_onSelectInit);
  }

  final ChatRepository _chatRepository;

  Future<void> _onSelectInit(SelectInit event, Emitter<SelectState> emit) async {

  }

}