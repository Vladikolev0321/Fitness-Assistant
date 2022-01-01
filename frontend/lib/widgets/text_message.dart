import 'package:flutter/material.dart';
import 'package:frontend/models/chat_message.dart';
import 'package:frontend/global.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key key, this.message,
  }) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: messagePadding * 0.75, 
        vertical: messagePadding / 2
        ),
      decoration: BoxDecoration(
        color: messagePrimaryColor.withOpacity(message.isSender ? 1 : 0.1),
        borderRadius: BorderRadius.circular(30)
      ),
            child: Text(
            message.text,
             style: TextStyle(
               color: message.isSender ? Colors.white : Theme.of(context).textTheme.bodyText1.color,
               ),
          ),
        );
  }
}

