class ChatResponse {
  final String text;
  final List<QuickReply>? quickReplies;
  final List<ChatSuggestion>? suggestions;
  final bool isTyping;
  final int? delay;

  ChatResponse({
    required this.text,
    this.quickReplies,
    this.suggestions,
    this.isTyping = false,
    this.delay,
  });
}

class QuickReply {
  final String id;
  final String text;
  final String? payload;

  QuickReply({required this.id, required this.text, this.payload});
}

class ChatSuggestion {
  final String id;
  final String text;
  final String? icon;

  ChatSuggestion({required this.id, required this.text, this.icon});
}
