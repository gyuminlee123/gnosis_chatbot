import 'package:flutter/material.dart';

import 'package:gnosis_chatbot/login/view/login_view.dart';

class TitlePage extends StatelessWidget {
  const TitlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TitleView();
  }
}

class TitleView extends StatefulWidget {
  const TitleView({Key? key}) : super(key: key);

  @override
  State<TitleView> createState() => _TitleViewState();
}

class _TitleViewState extends State<TitleView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(''), backgroundColor: Colors.white, elevation: 0,),
      body: TextButton(
        child: Text('Title'),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginPage()));
        }
      )
    );
  }
}

