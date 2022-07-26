import 'package:flutter/material.dart';
import 'package:gnosis_chatbot/constants.dart';

class NewMessage extends StatefulWidget {
  NewMessage({Key? key, required this.isReady, required this.onSend}) : super(key: key);

  final void Function(String) onSend;
  bool isReady = true;

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  _NewMessageState({Key? key});

  final _controller = TextEditingController();
  var _userEnterMessage = '';

  void _sendMessage() async{
     _controller.clear();
     _userEnterMessage = '';
     setState((){});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top:8),
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 25),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                maxLines: null,
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Send a message...',
                  floatingLabelStyle: TextStyle(color: Pallet.defaultColor),
                  focusedBorder: UnderlineInputBorder( borderSide: BorderSide(width:1, color: Pallet.defaultColor)),

                ),
                onChanged: (value) {
                  setState(() {
                    _userEnterMessage = value;
                  });
                },
              ),
            ),
            IconButton(
              onPressed: () {
                //message 가 없거나, State가 Ready 상태가 아니면 눌러도 반응X
                if(_userEnterMessage.trim().isEmpty || !widget.isReady) {

                } else
                  {
                    var sendMessage = _userEnterMessage;
                    _sendMessage();
                    widget.onSend(sendMessage);
                  }
              },
              icon: const Icon(Icons.send),
              color: (_userEnterMessage.trim().isEmpty || !widget.isReady) ? Colors.grey : Pallet.defaultColor,
            ),
          ],
        )
    );
  }
}