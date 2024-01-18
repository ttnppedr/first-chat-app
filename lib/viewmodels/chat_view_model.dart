import 'package:chat/chat.dart';
import 'package:first_chat_app/models/local_message.dart';
import 'package:first_chat_app/viewmodels/base_view_model.dart';

import '../data/datasources/datasource_contract.dart';
import '../models/chat.dart';

class ChatsViewModel extends BaseViewModel {
  IDatasource _datasource;
  String _chatId = '';
  int otherMessages = 0;
  String get chatId => _chatId;

  ChatsViewModel(this._datasource) : super(_datasource);

  Future<List<Chat>> getChats() async => await _datasource.findAllChats();

  Future<List<LocalMessage>> getMessages(String chatId) async {
    final messages = await _datasource.findMessages(chatId);
    if (messages.isNotEmpty) {
      _chatId = chatId;
    }
    return messages;
  }

  Future<void> sentMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.to, message, ReceiptStatus.sent);
    if (_chatId.isNotEmpty) {
      return await _datasource.addMessage(localMessage);
    }
    _chatId = localMessage.chatId!;
    await addMessage(localMessage);
  }

  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.from, message, ReceiptStatus.delivered);
    if (localMessage.chatId != _chatId) {
      otherMessages++;
    }
    await addMessage(localMessage);
  }
}
