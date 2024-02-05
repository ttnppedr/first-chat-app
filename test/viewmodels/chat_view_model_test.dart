import 'package:chat/chat.dart';
import 'package:first_chat_app/data/datasources/datasource_contract.dart';
import 'package:first_chat_app/models/chat.dart';
import 'package:first_chat_app/models/local_message.dart';
import 'package:first_chat_app/viewmodels/chat_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'chat_view_model_test.mocks.dart';

@GenerateNiceMocks([MockSpec<IDatasource>(as: #MockDatasource)])
void main() {
  ChatViewModel? sut;
  MockDatasource? mockDatasource;

  setUp(() {
    mockDatasource = MockDatasource();
    sut = ChatViewModel(mockDatasource!);
  });

  final message = Message.fromJson({
    'id': '1234',
    'from': '1234',
    'to': '4321',
    'contents': 'hey',
    'timestamp': DateTime.parse("2023-01-17"),
  });

  test('initial chats return empty list', () async {
    when(mockDatasource!.findMessages(any)).thenAnswer((_) async => []);
    expect(await sut!.getChats(), isEmpty);
  });

  test('returns list of messages from local message', () async {
    final chat = Chat('1234');
    final localMessage =
        LocalMessage(chat.id, message, ReceiptStatus.delivered);
    when(mockDatasource!.findMessages(chat.id))
        .thenAnswer((_) async => [localMessage]);
    final messages = await sut!.getMessages('1234');
    expect(messages, isNotEmpty);
    expect(messages.first.chatId, '1234');
  });

  test('creates a new chat when sending first message', () async {
    when(mockDatasource!.findChat(any)).thenAnswer((_) async => null);
    await sut!.sentMessage(message);
    verify(mockDatasource!.addChat(any)).called(1);
  });

  test('add new sent message to the chat', () async {
    final chat = Chat('1234');
    final localMessage =
        LocalMessage(chat.id, message, ReceiptStatus.delivered);
    when(mockDatasource!.findMessages(chat.id))
        .thenAnswer((_) async => [localMessage]);

    await sut!.getMessages(chat.id);
    await sut!.sentMessage(message);

    verifyNever(mockDatasource!.addChat(any));
    verify(mockDatasource!.addMessage(any)).called(1);
  });

  test('add new received message to the chat', () async {
    final chat = Chat('1234');
    final localMessage =
        LocalMessage(chat.id, message, ReceiptStatus.delivered);
    when(mockDatasource!.findMessages(chat.id))
        .thenAnswer((_) async => [localMessage]);
    when(mockDatasource!.findChat(chat.id)).thenAnswer((_) async => chat);

    await sut!.getMessages(chat.id);
    await sut!.receivedMessage(message);

    verifyNever(mockDatasource!.addChat(any));
    verify(mockDatasource!.addMessage(any)).called(1);
  });

  test('creates new chat when message received is not apart of this chat',
      () async {
    final chat = Chat('123');
    final localMessage =
        LocalMessage(chat.id, message, ReceiptStatus.delivered);
    when(mockDatasource!.findMessages(chat.id))
        .thenAnswer((_) async => [localMessage]);
    when(mockDatasource!.findChat(chat.id)).thenAnswer((_) async => null);

    await sut!.getMessages(chat.id);
    await sut!.receivedMessage(message);

    verify(mockDatasource!.addChat(any)).called(1);
    verify(mockDatasource!.addMessage(any)).called(1);
    expect(sut!.otherMessages, 1);
  });
}
