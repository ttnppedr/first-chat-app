import 'package:chat/chat.dart';
import 'package:first_chat_app/data/datasources/sqflite_datasource.dart';
import 'package:first_chat_app/models/chat.dart';
import 'package:first_chat_app/models/local_message.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import 'sqflite_datasource_test.mocks.dart';

// class MockSqfliteDatabase extends Mock implements Database {}
// class MockBatch extends Mock implements Batch {}

@GenerateNiceMocks([MockSpec<Database>(as: #MockSqfliteDatabase)])
@GenerateNiceMocks([MockSpec<Batch>(as: #MockBatch)])
void main() {
  SqfliteDatasource? sut;
  MockSqfliteDatabase? database;
  MockBatch? batch;

  setUp(() {
    database = MockSqfliteDatabase();
    batch = MockBatch();
    sut = SqfliteDatasource(database!);
  });

  final message = Message.fromJson({
    'id': '1234',
    'from': '1234',
    'to': '4321',
    'contents': 'hey',
    'timestamp': DateTime.parse("2023-01-17"),
  });

  test('should perform insert of chat to the database', () async {
    final chat = Chat('1234');
    when(database!.insert('chats', chat.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .thenAnswer((_) async => 1);

    await sut!.addChat(chat);

    verify(database!.insert('chats', chat.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .called(1);
  });

  test('should perform insert of message to the database', () async {
    final localMessage = LocalMessage('1234', message, ReceiptStatus.sent);

    when(database!.insert('messages', localMessage.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .thenAnswer((_) async => 1);

    await sut!.addMessage(localMessage);

    verify(database!.insert('messages', localMessage.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .called(1);
  });

  test('should perform a database query and return message', () async {
    final messagesMap = [
      {
        'chat_id': '1234',
        'id': '1234',
        'from': '1234',
        'to': '4321',
        'contents': 'hey',
        'receipt': 'sent',
        'timestamp': DateTime.parse("2023-01-17"),
      }
    ];

    when(database!.query(
      'messages',
      where: anyNamed('where'),
      whereArgs: anyNamed('whereArgs'),
    )).thenAnswer((_) async => messagesMap);

    var messages = await sut!.findMessages('1234');

    expect(messages.length, 1);
    expect(messages.first.chatId, '1234');
    verify(database!.query(
      'messages',
      where: anyNamed('where'),
      whereArgs: anyNamed('whereArgs'),
    )).called(1);
  });

  test('should perform database update a message', () async {
    final localMessage = LocalMessage('1234', message, ReceiptStatus.sent);

    when(database!.update(
      'messages',
      localMessage.toMap(),
      where: anyNamed('where'),
      whereArgs: anyNamed('whereArgs'),
    )).thenAnswer((_) async => 1);

    await sut!.updateMessage(localMessage);

    verify(database!.update(
      'messages',
      localMessage.toMap(),
      where: anyNamed('where'),
      whereArgs: anyNamed('whereArgs'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    )).called(1);
  });

  test('should perform database batch delete of chat', () async {
    final chatId = '111';
    when(database!.batch()).thenReturn(batch!);

    await sut!.deleteChat(chatId);

    verifyInOrder([
      database!.batch(),
      batch!.delete('messages', where: anyNamed('where'), whereArgs: [chatId]),
      batch!.delete('chats', where: anyNamed('where'), whereArgs: [chatId]),
      batch!.commit(noResult: true),
    ]);
  });
}
