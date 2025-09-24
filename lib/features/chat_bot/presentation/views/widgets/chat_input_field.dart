import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../shared/constants/language_manager.dart';

class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSend;
  final bool isArabic;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
    this.isArabic = true,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isComposing = widget.controller.text.isNotEmpty;
    });
  }

  void _handleSubmit() {
    if (widget.controller.text.trim().isNotEmpty) {
      widget.onSend(widget.controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              textDirection: widget.isArabic
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              decoration: InputDecoration(
                hintText: widget.isArabic
                    ? 'اكتب رسالة...'
                    : 'Type a message...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _handleSubmit(),
              onChanged: (_) => _onTextChanged(),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // TODO: Implement voice input
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        Provider.of<LanguageManager>(
                              context,
                              listen: false,
                            ).isArabic
                            ? 'ميزة الصوت قريباً!'
                            : 'Voice feature coming soon!',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.mic, color: Colors.grey, size: 24),
              ),
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: Material(
                  color: _isComposing
                      ? const Color(0xFF123459)
                      : Colors.grey[400],
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: _isComposing ? _handleSubmit : null,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.send,
                        color: _isComposing ? Colors.white : Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
