part of 'login_bloc.dart';

enum LoginStatus { first, informed }

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.first,
    this.username = '',
    this.email = '',
  });

  final LoginStatus status;
  final String username;
  final String email;

  LoginState copyWith({
    LoginStatus? status,
    String? username,
    String? email,
  }) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }

  @override
  List<Object> get props => [status,username,email];
}
