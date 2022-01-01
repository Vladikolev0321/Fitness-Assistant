enum ChatMessageType { text, audio, image, video, diagram }

class ChatMessage {
  final String text;
  final ChatMessageType messageType;
  final bool isSender;

  ChatMessage({
    this.text = '',
    this.messageType,
    this.isSender,
  });
}