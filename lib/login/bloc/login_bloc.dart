import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:gnosis_chatbot/repository/chatRepository.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required ChatRepository chatRepository,
  })  : _chatRepository = chatRepository,
        super(const LoginState()) {
    on<LoginInit>(_onLoginInit);
    on<LoginSave>(_onLoginSave);
  }

  final ChatRepository _chatRepository;

  String getUsername() {
    return _chatRepository.loadUsername(); }
  String getEmail() {
    return _chatRepository.loadEmail(); }

  void _onLoginInit(LoginInit event, Emitter<LoginState> emit) {

  }

  Future<void> _onLoginSave(LoginSave event, Emitter<LoginState> emit) async {
    await _chatRepository.saveLogInfo(event.username, event.email);
    emit(state.copyWith(
        status: LoginStatus.informed,
        username: event.username,
        email: event.email));
  }
}
