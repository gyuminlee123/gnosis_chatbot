import 'package:flutter/material.dart';
import 'package:gnosis_chatbot/constants.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_8.dart';
import 'package:extended_image/extended_image.dart';
import 'package:gnosis_chatbot/constants.dart';


//flutter_chat_bubble 2.0.0 ě íěŠí Bubble widget
class ChatBubbles extends StatelessWidget {
  const ChatBubbles(this.message, this.isMe, this.userName, this.isSensible, this.isSpecific, this.isInteresting, this.isDangerous, this.imageUrl, {Key? key})
      : super(key: key);

  final String message;
  final String userName;
  final bool isMe;
  final bool isSensible;
  final bool isSpecific;
  final bool isInteresting;
  final bool isDangerous;
  final String imageUrl;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(!isMe)
            CircleAvatar(
                radius: 25,
                backgroundImage: ExtendedNetworkImageProvider(
                  imageUrl,
                  cache: true,
              ),
            ),
          if(isMe)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: ChatBubble(
                clipper: ChatBubbleClipper8(type: BubbleType.sendBubble),
                alignment: Alignment.topRight,
                margin: const EdgeInsets.only(top: 10),
                backGroundColor: Pallet.humanBubbleColor,
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
              padding: const EdgeInsets.fromLTRB(0,20,0,0),
              child: ChatBubble(
                clipper: ChatBubbleClipper8(type: BubbleType.receiverBubble),
                backGroundColor: Pallet.aiBubbleColor,
                margin: const EdgeInsets.only(top: 0),
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
                      //ěëľě ëí ěŹěŠěě íęłź ę˛°ęłźëĽź íě
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