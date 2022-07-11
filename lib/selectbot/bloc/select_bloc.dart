import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'dart:convert';
import 'package:gnosis_chatbot/repository/chatRepository.dart';
import 'package:gnosis_chatbot/model/character.dart';

part 'select_state.dart';

part 'select_event.dart';

class SelectBloc extends Bloc<SelectEvent, SelectState> {
  SelectBloc({
    required ChatRepository chatRepository,
  })  : _chatRepository = chatRepository,
        super(SelectState()) {
    on<SelectInit>(_onSelectInit);
    on<SelectBeginChat>(_onSelectBeginChat);
  }

  final ChatRepository _chatRepository;

  Future<void> _onSelectInit(SelectInit event, Emitter<SelectState> emit) async {
    emit(state.copyWith(status : SelectStatus.init));
    List<Character> newCharList = <Character> [];
    List charList = await _chatRepository.getCharList();

    for( var character in charList ) {
      Character newCharacter = Character.fromJson(character);
      newCharList.add(newCharacter);
    }
    emit(state.copyWith(status : SelectStatus.ready, charList: newCharList));
  }

  Future<void> _onSelectBeginChat(SelectBeginChat event, Emitter<SelectState> emit) async {
    emit(state.copyWith(status : SelectStatus.selected));
  }

}