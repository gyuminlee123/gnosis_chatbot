import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gnosis_chatbot/repository/chatRepository.dart';
import 'package:gnosis_chatbot/login/bloc/login_bloc.dart';
import 'package:gnosis_chatbot/login/widgets/custom_text_form.dart';
import 'package:gnosis_chatbot/selectbot/view/select_view.dart';
import 'package:gnosis_chatbot/constants.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginBloc(chatRepository: context.read<ChatRepository>()),
      child: LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  //입력 데이터를 얻어오기 위한 key와 controller들.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController? userNameController;
  TextEditingController? emailController;
  late ScrollController _scrollController;

  @override
  initState() {
    super.initState();
    userNameController = TextEditingController(text: context.read<LoginBloc>().getUsername());
    emailController = TextEditingController(text: context.read<LoginBloc>().getEmail());
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    userNameController?.dispose();
    emailController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTextField() {
    _scrollController.animateTo(200.0, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        scrollDirection: Axis.vertical,
        controller: _scrollController,
        child: Column(
          children: [
            SizedBox(height: 100),
            //로그인 화면 로고
            Image.asset(
              'assets/coconem.png',
              height: 150,
              width: 150,
            ),
            SizedBox(height: 20),
            const Text(
              'Gnosis Prototype Bot',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            //username 입력
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    text: "Username",
                    type: inputStatus.name,
                    controller: userNameController,
                    onTap: () { _scrollTextField(); }
                  ),
                  const SizedBox(height: 5),
                  //Email 입력
                  CustomTextFormField(
                    text: "Email",
                    type: inputStatus.email,
                    controller: emailController,
                    onTap: () { _scrollTextField(); }
                  ),
                  const SizedBox(height: 20),
                  //Enter button
                  TextButton(
                    onPressed: () {
                      //username 과 Email 값이 유효한지 check 하고, 유효하면 chat room 으로 이동한다.
                      if (_formKey.currentState!.validate()) {
                        context.read<LoginBloc>().add(LoginSave(
                            username: userNameController!.text,
                            email: emailController!.text));

                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage(botname: 'jieun')));
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const SelectPage()));
                      } else {
                        print("Wrong values");
                      }
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Pallet.defaultColor,
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: Size(400, 60)),
                    child: const Text(
                      "Enter",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
