import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gnosis_chatbot/repository/chatRepository.dart';
import 'package:gnosis_chatbot/chat/bloc/chat_bloc.dart';
import 'package:gnosis_chatbot/chat/view/new_message.dart';
import 'package:gnosis_chatbot/chat/widget/chat_bubble.dart';
import 'package:gnosis_chatbot/model/message.dart';
import 'package:gnosis_chatbot/model/character.dart';
import 'package:gnosis_chatbot/constants.dart';
import 'dart:async';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key, required this.character}) : super(key: key);

  //character 이름을 character 선택화면에서 넘겨 받는다.
  final Character character;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      ChatBloc(chatRepository: context.read<ChatRepository>(), character: character)
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

  //한국어<->일어 전환버튼의 상태를 표시해준다.
  bool isKorean = true;

  //채팅창을 지워준다. AlertDialog안에서는 context를 읽지 못해 실행이 안된다.
  void _deleteChatRoom() {
    context.read<ChatBloc>().add(const ChatDeleteAll());
  }

  //평가내용을 서버로 전송한다.
  void _sendAssessment(index) {
    context.read<ChatBloc>().add(ChatSendAssess(index: index));
  }

  //한국어->일어 번역해주는 함수
  Future<String> _translateMsg(String message, bool isTranslate) async {
    String translatedMsg = message;
    if(isTranslate && message.isNotEmpty) {
      translatedMsg = await context.read<ChatRepository>().getTranslatedMsg(message, 'ko', 'ja');
      if(translatedMsg.isEmpty) translatedMsg = message;
    }
    return translatedMsg;
  }

  //사용언어 체크
  Future<String> _detectLangs(String text) async {
    String langCode = 'ko';
    if (text.length >= 2) {
      langCode = await context.read<ChatRepository>().detectLangs(text);
    }
    //print("LANGCODE!! $langCode");
    return langCode;
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('CHAT WITH AI BOT'),
        backgroundColor: Pallet.defaultColor,
        actions: [
          IconButton(
              onPressed: () {
                isKorean = isKorean ? false : true;
                setState(() {});
              },
              icon: Image.asset(isKorean ? 'assets/korean.png' : 'assets/japanese.png',width: 25, height: 25),
          ),
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
            icon: const Icon(Icons.delete)),
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
                        padding: const EdgeInsets.fromLTRB(10,10,0,10),
                        reverse: true,
                        itemCount: state.messageList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            //대화창을 클릭하면 키보드는 사라져야한다.
                            onTap: (){
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            //사용자 메세지를 클릭하면 무시한다.
                            onLongPress: () {
                              if(state.messageList[index].isUser) {
                                return;
                              }
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
                            child:
                            //파파고에서 일어 번역을 사용하는 경우 결과가 올때까지 대기 했다가
                            //표시해줘야한다. FutureBuilder를 사용한다.
                            FutureBuilder<String>(
                              future: _translateMsg(state.messageList[index].message, !isKorean),
                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                if(snapshot.hasData) {
                                  return ChatBubbles(
                                  snapshot.data ?? 'error',
                                  state.messageList[index].isUser,
                                  state.messageList[index].name,
                                  state.messageList[index].isSensible,
                                  state.messageList[index].isSpecific,
                                  state.messageList[index].isInteresting,
                                  state.messageList[index].isDangerous,
                                  state.character.imageurl);
                                }
                                else {
                                  return ChatBubbles(
                                      'Translating...',
                                      state.messageList[index].isUser,
                                      state.messageList[index].name,
                                      state.messageList[index].isSensible,
                                      state.messageList[index].isSpecific,
                                      state.messageList[index].isInteresting,
                                      state.messageList[index].isDangerous,
                                      state.character.imageurl);
                                }
                            }
                            )
                          );
                        },
                      ),
                    ),
                    NewMessage(
                        //status가 ready 상태가 아니면 입력을 받을 수 없다.
                        isReady: (state.status == ChatStatus.ready),
                        onSend: (message) async {
                          message = message.trim();
                          //어떤 언어로 쓰여졌는지 판별한다.
                          //일본어면 한국어로 번역해서 전달한다.
                          var langCode = await _detectLangs(message);
                          if( langCode == 'ja' ) {
                            message = await context.read<ChatRepository>().getTranslatedMsg(message, 'ja', 'ko');
                            //print(message);
                          }

                          //message send button 눌렸을때 일처리를 여기서 한다.
                          var newMessage = Message(isUser: true,
                              name: state.username,
                              email: state.email,
                              message: message);
                          state.messageList.insert(0, newMessage);
                          setState(() {});
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
