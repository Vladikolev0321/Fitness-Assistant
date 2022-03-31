import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/global.dart';
import 'package:frontend/models/chat_message.dart';
import 'text_message.dart';

class Message extends StatelessWidget {
  const Message({
    Key key,
    this.message
  }) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    Widget getMessageByType(ChatMessage message){
      switch(message.messageType){
        case ChatMessageType.text:
          return TextMessage(message: message,);
        case ChatMessageType.image:
          //return ImageMessage();
        default:
          return SizedBox();
      }
    }
    return Padding(
      padding: const EdgeInsets.only(top: messagePadding),
      child: Row(
        mainAxisAlignment: 
            message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if(!message.isSender) ...[
                CircleAvatar(
                  radius: 12,
                  child: Image.asset('assets/bot_avatar.png', color: Colors.white, ),
                ),
                SizedBox(width: messagePadding / 3,)
              ],
              getMessageByType(message)
            ],
      ),
    );
  }
}