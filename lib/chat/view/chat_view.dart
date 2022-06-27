import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gnosis_chatbot/repository/chatRepository.dart';
import 'package:gnosis_chatbot/chat/bloc/chat_bloc.dart';
import 'package:gnosis_chatbot/chat/view/new_message.dart';
import 'package:gnosis_chatbot/chat/widget/chat_bubble.dart';
import 'package:gnosis_chatbot/model/message.dart';
import 'package:gnosis_chatbot/constants.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key, required this.botname}) : super(key: key);

  //character 이름을 character 선택화면에서 넘겨 받는다.
  final String botname;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      ChatBloc(chatRepository: context.read<ChatRepository>())
        ..add(ChatInit(botname: botname)),
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

  //채팅창을 지워준다. AlertDialog안에서는 context를 읽지 못해 실행이 안된다.
  void _deleteChatRoom() {
    context.read<ChatBloc>().add(ChatDeleteAll());
  }

  //평가내용을 서버로 전송한다.
  void _sendAssessment(index) {
    context.read<ChatBloc>().add(ChatSendAssess(index: index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHAT WITH AI BOT'),
        actions: [
          //대화 목록 초기화여부를 AlertDialog를 띄워서 물어본다.
          IconButton(
            onPressed: (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20) ),
                    title: const Text('현재 대화를 삭제할까요?'),
                    actions: [
                      TextButton(
                        child: const Text('CANCEL'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          _deleteChatRoom();
                          Navigator.pop(context);
                        }
                      )
                  ],
                  );
                }
              );
            },
            icon: const Icon(Icons.delete))
        ]
      ),
      body: BlocListener<ChatBloc, ChatState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          //다른 상태에서 ready 상태로 돌아올때 setState를 호출해준다.
          if (state.status == ChatStatus.ready) {
            setState(() {});
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
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              showDialog(context: context,
                                builder: (BuildContext context) {

                                    return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20) ),
                                        title: Column(
                                          children: [
                                            const Text('Please Assess...',
                                                style:TextStyle(fontSize:20, fontWeight: FontWeight.bold,)),
                                            Text('\'${state.messageList[index].message}\'',
                                                style:const TextStyle(fontSize:15)),
                                            const Divider(thickness:1,color:Colors.grey),
                                          ],
                                        ),
                                        content:
                                        //showDialog에서 상태변화가 이루어지려면 StatefulBuilder를 사용해야한다.
                                        //Assessment 하는 4개 항목에 대해서 switchlisttile을 이용한다.
                                        StatefulBuilder(
                                          builder: (context,setState) {
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SwitchListTile(value: state.messageList[index].isSensible,
                                                  title: const Text('$kSensible Sensible'),
                                                  onChanged: (value) {
                                                    setState( () { state.messageList[index].isSensible = value; });
                                                  })
                                                ,
                                                const SizedBox(height:5),
                                                SwitchListTile(value: state.messageList[index].isSpecific,
                                                  title: const Text('$kSpecific Specific'),
                                                  onChanged: (value) {
                                                    setState( () { state.messageList[index].isSpecific = value; });
                                                  })
                                                ,
                                                const SizedBox(height:5),
                                                SwitchListTile(value: state.messageList[index].isInteresting,
                                                    title: const Text('$kInteresting Interesting'),
                                                    onChanged: (value) {
                                                      setState( () { state.messageList[index].isInteresting = value; });
                                                }),
                                                const SizedBox(height:5),
                                                SwitchListTile(value: state.messageList[index].isDangerous,
                                                    title: const Text('$kDangerous Dangerous'),
                                                    onChanged: (value) {
                                                      setState( () { state.messageList[index].isDangerous = value; });
                                                }),
                                              ],
                                            );
                                          }
                                        ),
                                        actions: [
                                          TextButton(
                                            child: const Text('CANCEL'),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                          TextButton(
                                            child: const Text('OK'),
                                            onPressed: () {
                                              //평가내용을 서버로 전송
                                              _sendAssessment(index);
                                              Navigator.pop(context);
                                            }
                                          )
                                        ],
                                        elevation: 15.0,
                                    );
                                },
                              );
                            },
                            child: ChatBubbles(
                                state.messageList[index].message,
                                state.messageList[index].isUser,
                                state.messageList[index].name),
                          );
                        },
                      ),
                    ),
                    NewMessage(
                        //status가 ready 상태가 아니면 입력을 받을 수 없다.
                        isReady: (state.status == ChatStatus.ready),
                        onSend: (message) {
                          //message send button 눌렸을때 일처리를 여기서 한다.
                          var newMessage = Message(isUser: true,
                              name: state.username,
                              email: state.email,
                              message: message);
                          state.messageList.insert(0, newMessage);
                          setState(() {
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
