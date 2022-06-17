import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gnosis_chatbot/repository/chatRepository.dart';
import 'package:gnosis_chatbot/login/bloc/login_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gnosis_chatbot/login/widgets/custom_text_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(chatRepository: context.read<ChatRepository>()),
      child: LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {

  //입력 데이터를 얻어오기 위한 key와 controller들.
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: [
            SizedBox(height: 60),
            //로그인 화면 로고
            SvgPicture.asset(
              'assets/chatbot.svg',
              height: 200,
              width: 200,
            ),
            const Text(
              'Gnosis Prototype Bot',
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            //username 입력
            CustomTextFormField(text: "Username", type: inputStatus.name, controller: userNameController,),
            const SizedBox(height: 15),
            //Email 입력
            CustomTextFormField(text: "Email", type: inputStatus.email, controller: emailController,),
            const SizedBox(height: 50),
            //Enter button
            TextButton(
              onPressed: () {
                if(_formKey.currentState!.validate()) {
                  print(userNameController.text);
                  print(emailController.text);
                }
                else {
                  print("Wrong values");
                }
              },
              child: Text("Enter", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                primary: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),
                minimumSize: Size(400,60)
              ),
            ),
          ],
        ),

      )
    );
  }
}




