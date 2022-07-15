import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gnosis_chatbot/repository/chatRepository.dart';
import 'package:gnosis_chatbot/login/view/login_view.dart';
import 'package:gnosis_chatbot/title/view/title_view.dart';

class App extends StatelessWidget {
  const App({Key? key, required this.chatRepository}) : super(key: key);

  final ChatRepository chatRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: chatRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TitlePage(),
      //home: const LoginPage(),
    );
  }
}

