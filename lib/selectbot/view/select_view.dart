import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gnosis_chatbot/repository/chatRepository.dart';
import 'package:gnosis_chatbot/selectbot/bloc/select_bloc.dart';
import 'package:gnosis_chatbot/chat/view/chat_view.dart';


class SelectPage extends StatelessWidget {
  const SelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      SelectBloc(chatRepository: context.read<ChatRepository>()),
      child: const SelectView(),
    );
  }
}

class SelectView extends StatefulWidget {
  const SelectView({Key? key}) : super(key: key);

  @override
  State<SelectView> createState() => _SelectViewState();
}

class _SelectViewState extends State<SelectView> {
  @override
  void initState() {
    super.initState();
    context.read<SelectBloc>().add(SelectInit());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Choose Character')),
      body: TextButton(
        child:Text('press'),
        onPressed: (){
          context.read<SelectBloc>().add(SelectBeginChat());
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage(botname: 'jieun')));
        },
      ),
    );
  }
}
