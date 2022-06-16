import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:gnosis_chatbot/repository/chatRepository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required ChatRepository chatRepository,
}) : _chatRepository = chatRepository,
  super(const LoginState()) {
    on<LoginInit>(_onLoginInit);
  }

  final ChatRepository _chatRepository;

  Future<void> _onLoginInit(
      LoginInit event, Emitter<LoginState> emit
      ) async {}

}