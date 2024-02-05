import 'package:first_chat_app/models/chat.dart';
import 'package:first_chat_app/viewmodels/chats_view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsCubit extends Cubit<List<Chat>> {
  final ChatsViewModel viewModel;

  ChatsCubit(this.viewModel) : super([]);

  Future<void> chats() async {
    final chats = await viewModel.getChats();
    emit(chats);
  }
}
