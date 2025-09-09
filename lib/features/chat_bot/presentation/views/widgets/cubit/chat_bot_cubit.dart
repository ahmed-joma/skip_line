import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chat_bot_state.dart';

class ChatBotCubit extends Cubit<ChatBotState> {
  ChatBotCubit() : super(ChatBotInitial());
}
