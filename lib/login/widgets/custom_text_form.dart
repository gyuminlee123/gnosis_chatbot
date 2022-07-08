import 'package:flutter/material.dart';
import 'package:gnosis_chatbot/login/bloc/login_bloc.dart';

enum inputStatus { email, pass, name }

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {Key? key,
      required this.text,
      required this.type,
      required this.controller,
      required this.onTap,
      })
      : super(key: key);
  final String text;
  final inputStatus type;
  final TextEditingController? controller;

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text),
        const SizedBox(height: 5.0),
        TextFormField(
          onTap: onTap,
          controller: controller,
          validator: (value) {
            print('$text validation check');
            if (value!.isEmpty) {
              return 'Please Enter $text';
            }
            if (type == inputStatus.email) {
              RegExp regExp = RegExp(
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}'
                  r'\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
              if (!regExp.hasMatch(value)) {
                return 'Wrong Email address';
              }
            }
            return null;
          },
          keyboardType: type == inputStatus.email
              ? TextInputType.emailAddress
              : TextInputType.name,
          obscureText:
              // 2. 해당 TextFormField가 비밀번호 입력 양식이면 **** 처리 해주기
              type == inputStatus.pass ? true : false,
          decoration: InputDecoration(
            hintText: "Enter $text",
            enabledBorder: OutlineInputBorder(
              // 3. 기본 TextFormField 디자인
              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              // 4. 손가락 터치시 TextFormField 디자인
              borderSide: const BorderSide(color: Colors.grey, width: 2.0),
              borderRadius: BorderRadius.circular(20),
            ),
            errorBorder: OutlineInputBorder(
              // 5. 에러발생시 TextFormField 디자인
              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedErrorBorder: OutlineInputBorder(
              // 5. 에러가 발생 후 손가락을 터치했을 때 TextFormField 디자인
              borderSide: const BorderSide(color: Colors.grey, width: 2.0),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }
}
