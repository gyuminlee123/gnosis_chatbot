part of 'select_bloc.dart';

abstract class SelectEvent extends Equatable {
  const SelectEvent();

  @override
  List<Object> get props => [];
}

//초기화
class SelectInit extends SelectEvent {
  const SelectInit();
}

//
class SelectBeginChat extends SelectEvent {
  const SelectBeginChat();
}