import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../shared/constants/language_manager.dart';
import '../manager/chat_bot/chat_bot_cubit.dart';
import '../manager/chat_bot/chat_bot_state.dart';
import 'widgets/chat_message_bubble.dart';
import 'widgets/chat_input_field.dart';
import 'widgets/chat_suggestions.dart';
import 'widgets/typing_indicator.dart';

class ChatBotView extends StatefulWidget {
  const ChatBotView({super.key});

  @override
  State<ChatBotView> createState() => _ChatBotViewState();
}

class _ChatBotViewState extends State<ChatBotView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageManager>(
      builder: (context, languageManager, child) {
        return BlocProvider(
          create: (context) =>
              ChatBotCubit()
                ..initializeChat(isArabic: languageManager.isArabic),
          child: Scaffold(
            backgroundColor: const Color(0xFFF8F9FA),
            appBar: _buildAppBar(),
            body: Column(
              children: [
                Expanded(
                  child: BlocConsumer<ChatBotCubit, ChatBotState>(
                    listener: (context, state) {
                      if (state is ChatBotMessagesUpdated) {
                        _scrollToBottom();
                      }
                    },
                    builder: (context, state) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            Expanded(child: _buildMessagesList()),
                            BlocBuilder<ChatBotCubit, ChatBotState>(
                              builder: (context, state) {
                                if (state is ChatBotTyping && state.isTyping) {
                                  return const TypingIndicator();
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                            BlocBuilder<ChatBotCubit, ChatBotState>(
                              builder: (context, state) {
                                if (state is ChatBotSuggestionsUpdated) {
                                  return ChatSuggestions(
                                    suggestions: state.suggestions,
                                    onSuggestionTap: (suggestion) {
                                      context
                                          .read<ChatBotCubit>()
                                          .sendSuggestion(
                                            suggestion,
                                            isArabic: languageManager.isArabic,
                                          );
                                    },
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                _buildInputArea(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessagesList() {
    return BlocBuilder<ChatBotCubit, ChatBotState>(
      builder: (context, state) {
        final cubit = context.read<ChatBotCubit>();
        final messages = cubit.messages;

        if (messages.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF123459)),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return ChatMessageBubble(
              message: message,
              isLast: index == messages.length - 1,
            );
          },
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Consumer<LanguageManager>(
      builder: (context, languageManager, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE5E5E5), width: 1)),
          ),
          child: SafeArea(
            child: ChatInputField(
              controller: _messageController,
              isArabic: languageManager.isArabic,
              onSend: (message) {
                if (message.trim().isNotEmpty) {
                  context.read<ChatBotCubit>().sendMessage(
                    message,
                    isArabic: languageManager.isArabic,
                  );
                  _messageController.clear();
                }
              },
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF123459),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SkiBot',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  CircleAvatar(radius: 4, backgroundColor: Colors.green),
                  SizedBox(width: 6),
                  Text(
                    'Always active',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black, size: 20),
            onPressed: () => _showOptionsMenu(),
          ),
        ),
      ],
    );
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            _buildMenuOption(
              icon: Icons.clear_all,
              title: 'مسح المحادثة',
              onTap: () {
                Navigator.pop(context);
                context.read<ChatBotCubit>().clearChat();
              },
            ),
            _buildMenuOption(
              icon: Icons.help_outline,
              title: 'مساعدة',
              onTap: () {
                Navigator.pop(context);
                context.read<ChatBotCubit>().sendMessage('مساعدة');
              },
            ),
            _buildMenuOption(
              icon: Icons.info_outline,
              title: 'حول SkiBot',
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF123459)),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.smart_toy, color: Color(0xFF123459)),
            SizedBox(width: 8),
            Text('About SkiBot'),
          ],
        ),
        content: const Text(
          'SkiBot هو مساعدك الذكي للتسوق. يمكنني مساعدتك في البحث عن المنتجات، حل المشاكل، وإدارة حسابك.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
