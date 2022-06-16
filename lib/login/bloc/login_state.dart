part of 'login_bloc.dart';

enum LoginStatus { first, old }

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.first,
  });

  final LoginStatus status;

  @override
  List<Object> get props => [status];
}
