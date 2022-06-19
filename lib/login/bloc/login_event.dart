part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginInit extends LoginEvent {
  const LoginInit();

  final String username = '';
  final String email = '';

}

class LoginSave extends LoginEvent {
  const LoginSave({
    required this.username,
    required this.email
});

  final String username;
  final String email;
}