import 'package:flutter/material.dart';
import '../../../data/models/chat_message.dart';
import '../../../data/models/chat_response.dart' as response;

@immutable
sealed class ChatBotState {}

final class ChatBotInitial extends ChatBotState {}

final class ChatBotMessagesUpdated extends ChatBotState {
  final List<ChatMessage> messages;

  ChatBotMessagesUpdated(this.messages);
}

final class ChatBotTyping extends ChatBotState {
  final bool isTyping;

  ChatBotTyping(this.isTyping);
}

final class ChatBotSuggestionsUpdated extends ChatBotState {
  final List<response.ChatSuggestion> suggestions;

  ChatBotSuggestionsUpdated(this.suggestions);
}
