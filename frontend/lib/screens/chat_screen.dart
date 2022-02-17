import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/global.dart';
import 'package:frontend/models/chat_message.dart';
import 'package:frontend/providers/messages.dart';
import 'package:frontend/widgets/message.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({ Key key }) : super(key: key);

  @override
  _ChatBodyState createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {

  ScrollController _scrollController = new ScrollController();
  
  List demoChatMessages = [
    ChatMessage(
      text: "Hi Vladi",
      messageType: ChatMessageType.text,
      isSender: false,
    ),
    ChatMessage(
      text: "Hello, How are you?",
      messageType: ChatMessageType.text,
      isSender: true,
    )];


  void addMessage(String message, bool isSender) {
    setState(() {
      demoChatMessages.add(ChatMessage(
        text: message,
        messageType: ChatMessageType.text,
        isSender: isSender ? true : false,
    ));
      Timer(Duration(milliseconds: 500),
            () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
    });
  }




  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: messagePadding),
            child: ListView.builder(
              itemCount: demoChatMessages.length,
              itemBuilder: (context, index) => Message(message: demoChatMessages[index]),
              controller: _scrollController,
              ),
          ),
          ),
        ChatInputField(notifyParent: addMessage,),
        
      ],
    );
  }

}

class ChatInputField extends StatelessWidget {
  final Function notifyParent;

  ChatInputField({Key key, this.notifyParent}) : super(key: key);
  
  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: messagePadding,
        vertical: messagePadding / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: messagePadding * 0.75,
                ),
                decoration: BoxDecoration(
                  color: messagePrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    SizedBox(width: messagePadding / 4),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Type message",
                          border: InputBorder.none,
                        ),
                        onSubmitted: (msg){
                          this.getResponse(context);
                        },
                        controller: _messageController,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> getResponse(BuildContext context) async {
    String text = _messageController.text;
    if(text.length > 0){
      _messageController.text = "";
      this.notifyParent(text, true);
      String response = await Provider.of<Messages>(context, listen: false).message(text);
      print(response);
      if(response != null){
        this.notifyParent(response.toString(), false);
      }
    }
  }

}