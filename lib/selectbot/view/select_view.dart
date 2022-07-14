import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gnosis_chatbot/repository/chatRepository.dart';
import 'package:gnosis_chatbot/selectbot/bloc/select_bloc.dart';
import 'package:gnosis_chatbot/chat/view/chat_view.dart';
import 'package:extended_image/extended_image.dart';
import 'package:gnosis_chatbot/constants.dart';


class SelectPage extends StatelessWidget {
  const SelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      SelectBloc(chatRepository: context.read<ChatRepository>()),
      child: const SelectView(),
    );
  }
}

class SelectView extends StatefulWidget {
  const SelectView({Key? key}) : super(key: key);

  @override
  State<SelectView> createState() => _SelectViewState();
}

class _SelectViewState extends State<SelectView> {
  @override
  void initState() {
    super.initState();
    context.read<SelectBloc>().add(SelectInit());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Character'), backgroundColor: Pallet.defaultColor),
      body: BlocBuilder<SelectBloc, SelectState> (
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.charList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  SizedBox(height:15),
                  InkWell(
                    onTap: () {
                      context.read<SelectBloc>().add(SelectBeginChat());
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>ChatPage(character: state.charList[index])));
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: ExtendedNetworkImageProvider(
                            state.charList[index].imageurl,
                            cache: true,
                        )
                      ),
                      title: Text(state.charList[index].name),
                      subtitle: Text('${state.charList[index].description.substring(0,50)}...'),
                    )
                  ),
                ],
              );
            }
          );
        }
      )

      /*body: TextButton(
        child:Text('press'),
        onPressed: (){

        },*/

      );
  }
}
