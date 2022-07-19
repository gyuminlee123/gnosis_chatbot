import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gnosis_chatbot/repository/chatRepository.dart';
import 'package:gnosis_chatbot/app/app.dart';
import 'package:gnosis_chatbot/app/app_bloc_observer.dart';

//for appcenter
//import 'package:flutter_appcenter_bundle/flutter_appcenter_bundle.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //for appcenter
 // await AppCenter.startAsync(
 //   appSecretAndroid: '076d890f-4dc0-43af-96d3-997f70bb4eca',
 //   appSecretIOS: '2da3d93f-6b3f-48f9-920f-2d63ae3cd25a',
  //  enableDistribute: false,
  //);
 // await AppCenter.configureDistributeDebugAsync(enabled: false);

  final chatRepository = ChatRepository( plugin: await SharedPreferences.getInstance());

  BlocOverrides.runZoned(
    () => runApp(
      App(chatRepository: chatRepository),
    ),
    blocObserver: AppBlocObserver(),
  );
}