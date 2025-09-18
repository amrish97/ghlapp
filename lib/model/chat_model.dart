class ChatMessage {
  final String text;
  final bool isSender;
  final String attachment;

  ChatMessage({
    required this.text,
    required this.isSender,
    required this.attachment,
  });
}
