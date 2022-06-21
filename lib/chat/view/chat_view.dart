import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gnosis_chatbot/repository/chatRepository.dart';
import 'package:gnosis_chatbot/chat/bloc/chat_bloc.dart';
import 'package:gnosis_chatbot/chat/view/new_message.dart';
import 'package:gnosis_chatbot/chat/widget/chat_bubble.dart';
import 'package:gnosis_chatbot/model/message.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChatBloc(chatRepository: context.read<ChatRepository>())
            ..add(const ChatInit()),
      child: const ChatView(),
    );
  }
}

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PROTO TYPE CHATTER BOT')),
      body: BlocListener<ChatBloc, ChatState> (
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if(state.status == ChatStatus.ready) {
            setState((){});
          }
        },
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: state.messageList.length,
                      itemBuilder: (context,index) {
                        return ChatBubbles(
                            state.messageList[index].message,
                            state.messageList[index].isUser,
                            state.messageList[index].name);
                      },
                    ),
                  ),
                  NewMessage(
                      isReady : (state.status == ChatStatus.ready),
                      onSend: (message) {
                        //message send button 눌렸을때 일처리를 여기서 한다.
                        var newMessage = Message(isUser: true, name: state.username, time: DateTime.now(), message: message);
                        state.messageList.insert(0,newMessage);
                        setState((){
                          print("setState1");
                        });
                        context.read<ChatBloc>().add(
                          ChatSendMsg(message: message)
                        );
                      }),
                ]
            );
          }
        ),
      ),
    );
  }
}
