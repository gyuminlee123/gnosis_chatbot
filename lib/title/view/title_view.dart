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

class _TitleViewState extends State<TitleView> with TickerProviderStateMixin {

  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    );

    _controller.addListener(() {
      if(_controller.isCompleted) {
        _goLoginPage();
      }
    });

    _controller.forward();
  }

  void _goLoginPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: null,
      body: InkWell(
        onTap: () {
          _goLoginPage();
        },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: FadeTransition(
                opacity: _animation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/coconemlogo.png"),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}

