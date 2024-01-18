import 'package:first_chat_app/data/datasources/datasource_contract.dart';
import 'package:first_chat_app/models/local_message.dart';
import 'package:flutter/foundation.dart';

import '../models/chat.dart';

abstract class BaseViewModel {
  IDatasource _database;

  BaseViewModel(this._database);

  @protected
  Future<void> addMessage(LocalMessage message) async {
    if (!await _isExistingChat(message.chatId)) {
      await _createNewChat(message.chatId);
    }
    await _database.addMessage(message);
  }

  Future<bool> _isExistingChat(String? chatId) async {
    return await _database.findChat(chatId!) != null;
  }

  Future<void> _createNewChat(String? chatId) async {
    final chat = Chat(chatId!);
    await _database.addChat(chat);
  }
}
