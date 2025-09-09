import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/chat_message.dart';
import '../../../data/models/chat_response.dart';
import '../../../data/services/chat_bot_service.dart';

import 'chat_bot_state.dart';

class ChatBotCubit extends Cubit<ChatBotState> {
  ChatBotCubit() : super(ChatBotInitial());

  final List<ChatMessage> _messages = [];
  final Uuid _uuid = const Uuid();

  List<ChatMessage> get messages => List.unmodifiable(_messages);

  void sendMessage(String text, {bool isArabic = true}) {
    if (text.trim().isEmpty) return;

    // إضافة رسالة المستخدم
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    _messages.add(userMessage);
    emit(ChatBotMessagesUpdated(_messages));

    // محاكاة الكتابة
    emit(ChatBotTyping(true));

    // إرسال رد تلقائي بعد تأخير قصير
    Future.delayed(const Duration(milliseconds: 1500), () {
      _sendBotResponse(text, isArabic: isArabic);
    });
  }

  void sendSuggestion(String suggestion, {bool isArabic = true}) {
    sendMessage(suggestion, isArabic: isArabic);
  }

  void _sendBotResponse(String userMessage, {bool isArabic = true}) {
    final response = ChatBotService.getResponse(
      userMessage,
      isArabic: isArabic,
    );

    // إيقاف مؤشر الكتابة
    emit(ChatBotTyping(false));

    // إضافة رد البوت
    final botMessage = ChatMessage(
      id: _uuid.v4(),
      text: response.text,
      isUser: false,
      timestamp: DateTime.now(),
    );

    _messages.add(botMessage);
    emit(ChatBotMessagesUpdated(_messages));

    // إرسال الاقتراحات إذا كانت موجودة، وإلا إظهار الاقتراحات العامة
    if (response.suggestions != null && response.suggestions!.isNotEmpty) {
      emit(ChatBotSuggestionsUpdated(response.suggestions!));
    } else {
      // إظهار الاقتراحات العامة بعد كل رد
      emit(
        ChatBotSuggestionsUpdated(
          ChatBotService.getWelcomeSuggestions(isArabic: isArabic),
        ),
      );
    }
  }

  void clearChat() {
    _messages.clear();
    emit(ChatBotMessagesUpdated(_messages));
    emit(ChatBotSuggestionsUpdated([]));
  }

  void initializeChat({bool isArabic = true}) {
    _messages.clear();

    // رسالة ترحيب
    final welcomeText = isArabic
        ? 'مرحباً! أنا SkiBot، مساعدك الشخصي للتسوق الذكي. كيف يمكنني مساعدتك اليوم؟'
        : 'Hello! I\'m SkiBot, your personal shopping assistant. How can I help you today?';

    final welcomeMessage = ChatMessage(
      id: _uuid.v4(),
      text: welcomeText,
      isUser: false,
      timestamp: DateTime.now(),
    );

    _messages.add(welcomeMessage);
    emit(ChatBotMessagesUpdated(_messages));
    emit(
      ChatBotSuggestionsUpdated(
        ChatBotService.getWelcomeSuggestions(isArabic: isArabic),
      ),
    );
  }
}
