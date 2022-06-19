import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key, required this.onSend}) : super(key: key);

  final void Function(String) onSend;

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
        margin: EdgeInsets.only(top:8),
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                maxLines: null,
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Send a message...',
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
                if(_userEnterMessage.trim().isEmpty) {

                } else
                  {
                    var sendMessage = _userEnterMessage;
                    _sendMessage();
                    widget.onSend(sendMessage);
                  }
              },
              icon: const Icon(Icons.send), color: _userEnterMessage.trim().isEmpty ? Colors.grey : Colors.blueAccent,),
          ],
        )
    );
  }
}