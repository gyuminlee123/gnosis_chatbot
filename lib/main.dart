import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gnosis_chatbot/repository/chatRepository.dart';
import 'package:gnosis_chatbot/app/app.dart';
import 'package:gnosis_chatbot/app/app_bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final chatRepository = ChatRepository( plugin: await SharedPreferences.getInstance());

  BlocOverrides.runZoned(
    () => runApp(
      App(chatRepository: chatRepository),
    ),
    blocObserver: AppBlocObserver(),
  );
}