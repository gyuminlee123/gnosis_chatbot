import 'package:flutter/material.dart';
import 'package:gnosis_chatbot/constants.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_8.dart';

//flutter_chat_bubble 2.0.0 을 활용한 Bubble widget
class ChatBubbles extends StatelessWidget {
  const ChatBubbles(this.message, this.isMe, this.userName, this.isSensible, this.isSpecific, this.isInteresting, this.isDangerous, {Key? key})
      : super(key: key);

  final String message;
  final String userName;
  final bool isMe;
  final bool isSensible;
  final bool isSpecific;
  final bool isInteresting;
  final bool isDangerous;

  String _assessString() {
    String assessStr = '';
    assessStr = '$assessStr$kSensible${isSensible ? '1' : '0'} ';
    assessStr = '$assessStr$kSpecific${isSpecific ? '1' : '0'} ';
    assessStr = '$assessStr$kInteresting${isInteresting ? '1' : '0'} ';
    assessStr = '$assessStr$kDangerous${isDangerous ? '1' : '0'} ';
    return assessStr;
  }

  @override
  Widget build(BuildContext context) {
    return
      Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if(isMe)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: ChatBubble(
                clipper: ChatBubbleClipper8(type: BubbleType.sendBubble),
                alignment: Alignment.topRight,
                margin: const EdgeInsets.only(top: 20),
                backGroundColor: Colors.blue,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery
                        .of(context)
                        .size
                        .width * 0.7,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(userName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if(!isMe)
            Padding(
              padding: const EdgeInsets.fromLTRB(15,0,0,0),
              child: ChatBubble(
                clipper: ChatBubbleClipper8(type: BubbleType.receiverBubble),
                backGroundColor: Colors.white70,
                margin: const EdgeInsets.only(top: 20),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        message,
                        style: const TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 5),
                      //응답에 대한 사용자의 평과 결과를 표시
                      Text(
                        _assessString(),
                        style: const TextStyle(color: Colors.orange),
                      )
                    ],
                  ),
                ),
              ),
            )
        ],
      );
  }
}