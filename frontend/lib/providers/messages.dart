import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/models/chat_message.dart';
import 'package:frontend/providers/strava_fitbit.dart';
import 'package:frontend/secret.dart';
import 'package:http/http.dart' as http;

class Messages {
  final _user = FirebaseAuth.instance.currentUser;
  StravaFitbitProvider _stravaFitbitProvider;
  List<ChatMessage> _messages = [];

  Messages(this._stravaFitbitProvider);

  List<ChatMessage> get messages => _messages;

  void addMessage(String message, bool isSender){
    _messages.add(ChatMessage(
        text: message,
        messageType: ChatMessageType.text,
        isSender: isSender ? true : false,));
  }

  Future<String> message(String message) async {
    final idToken = await _user.getIdToken();

    http.Client client = getClient();
    final response = await client.post(
      Uri.parse("$baseUrl/bot/message"),
      headers: {
        'Content-type': 'application/json',
        "Authorization": idToken
      },
      body: json.encode({"message": message}),
    );
    if(response.statusCode == 200){  
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['response'];
    }
    return "Problem occured responding";
  }

  http.Client getClient() {
    return http.Client();
  }
}
