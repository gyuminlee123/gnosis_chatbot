part of 'select_bloc.dart';

enum SelectStatus { init, ready, selected }

class SelectState extends Equatable {
  SelectState({this.status = SelectStatus.init, this.charList = const <Character> []});

  final SelectStatus status;
  List<Character> charList;

  SelectState copyWith({
    SelectStatus? status,
    List<Character>? charList,
  }) {
    return SelectState(
      status: status ?? this.status,
      charList: charList ?? this.charList,
    );
  }

  @override
  List<Object> get props => [status, charList];
}