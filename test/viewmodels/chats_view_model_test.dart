import 'package:chat/chat.dart';
import 'package:first_chat_app/data/datasources/datasource_contract.dart';
import 'package:first_chat_app/models/chat.dart';
import 'package:first_chat_app/viewmodels/chat_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'chats_view_model_test.mocks.dart';

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
    when(mockDatasource!.findAllChats()).thenAnswer((_) async => []);
    expect(await sut!.getChats(), isEmpty);
  });

  test('returns list of chats', () async {
    final chat = Chat('123');
    when(mockDatasource!.findAllChats()).thenAnswer((_) async => [chat]);
    expect(await sut!.getChats(), isNotEmpty);
  });

  test('creates a new chat when receiving message from the first time',
      () async {
    when(mockDatasource!.findChat(any)).thenAnswer((_) async => null);
    await sut!.receivedMessage(message);
    verify(mockDatasource!.addChat(any)).called(1);
  });

  test('add new message to existing chat', () async {
    final chat = Chat('123');

    when(mockDatasource!.findChat(any)).thenAnswer((_) async => chat);
    await sut!.receivedMessage(message);
    verifyNever(mockDatasource!.addChat(any));
    verify(mockDatasource!.addMessage(any)).called(1);
  });
}
