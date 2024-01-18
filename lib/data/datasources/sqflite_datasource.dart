import 'package:first_chat_app/data/datasources/datasource_contract.dart';
import 'package:first_chat_app/models/chat.dart';
import 'package:first_chat_app/models/local_message.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDatasource implements IDatasource {
  final Database _db;

  const SqfliteDatasource(this._db);

  @override
  Future<void> addChat(Chat chat) async {
    await _db.insert('chats', chat.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> addMessage(LocalMessage message) async {
    await _db.insert('messages', message.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final batch = _db.batch();
    batch.delete('messages', where: 'chat_id = ?', whereArgs: [chatId]);
    batch.delete('chats', where: 'id = ?', whereArgs: [chatId]);
    await batch.commit(noResult: true);
  }

  @override
  Future<List<Chat>> findAllChats() {
    return _db.transaction((txn) async {
      final chatsWithLatestMessages = await txn.rawQuery(
          '''SELECT messages.* FROM (SELECT chat_id, MAX(created_at) AS created_at FROM messages GROUP BY chat_id) AS latest_message INNER JSON messages ON messages.chat_id = latest_message.chat_id AND messages.created_at = latest_message.created_at''');

      final chatsWithUnreadMessages = await txn.rawQuery(
          '''SELECT chat_id, count(*) AS unread FROM messages WHERE receipt= ? GROUP BY chat_id''',
          ['delivered']);

      return chatsWithLatestMessages.map<Chat>((row) {
        final int? unread = int.tryParse(chatsWithUnreadMessages.firstWhere(
            (ele) => row['chat_id'] == ele['chat_id'],
            orElse: () => {'unread': 0})['unread'] as String);

        final chat = Chat.fromMap(row);
        chat.unread = unread!;
        chat.mostRecent = LocalMessage.fromMap(row);
        return chat;
      }).toList();
    });
  }

  @override
  Future<Chat> findChat(String chatId) async {
    return _db.transaction((txn) async {
      final listOfChatMaps = await txn.query(
        'chats',
        where: 'id = ?',
        whereArgs: [chatId],
      );

      final unread = Sqflite.firstIntValue(await txn.rawQuery(
          'SELECT COUNT(*) FROM messages WHERE chat_id = ? AND receipt = ?',
          [chatId, 'delivered']));

      final mostRecentMessage = await txn.query(
        'messages',
        where: 'chat_id = ?',
        whereArgs: [chatId],
        orderBy: 'created_at DESC',
        limit: 1,
      );

      final chat = Chat.fromMap(listOfChatMaps.first);
      chat.unread = unread!;
      chat.mostRecent = LocalMessage.fromMap(mostRecentMessage.first);
      return chat;
    });
  }

  @override
  Future<List<LocalMessage>> findMessages(String chatId) async {
    final listOfMaps =
        await _db.query('messages', where: 'chat_id = ?', whereArgs: [chatId]);

    return listOfMaps
        .map<LocalMessage>((map) => LocalMessage.fromMap(map))
        .toList();
  }

  @override
  Future<void> updateMessage(LocalMessage message) async {
    await _db.update(
      'messages',
      message.toMap(),
      where: 'id = ?',
      whereArgs: [message.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}