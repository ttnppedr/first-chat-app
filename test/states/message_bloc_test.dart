import 'package:chat/chat.dart';
import 'package:first_chat_app/states_management/message/message_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'message_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<IMessageService>(as: #FakeMessageService)])
void main() {
  MessageBloc? sut;
  IMessageService? messageService;
  User? user;

  setUp(() {
    messageService = FakeMessageService();
    user = User(
      username: 'test',
      photoUrl: '',
      active: true,
      lastseen: DateTime.now(),
    );
    sut = MessageBloc(messageService!);
  });

  tearDown(() => sut!.close());

  test('should emit initial only without subscriptions', () async {
    expect(sut!.state, MessageInitial());
  });

  test('should emit message sent state when message is sent', () async {
    final message = Message(
      from: '123',
      to: '321',
      contents: 'hey',
      timestamp: DateTime.now(),
    );

    when(messageService!.send(message)).thenAnswer((_) async => true);
    sut!.add(MessageEvent.onMessageSent(message));
    expectLater(sut!.stream, emits(MessageState.sent(message)));
  });

  test('should emit message received from server', () async {
    final message = Message(
      from: '123',
      to: '321',
      contents: 'test message',
      timestamp: DateTime.now(),
    );

    when(messageService!.messages(activeUser: user!))
        .thenAnswer((_) => Stream.fromIterable([message]));
    sut!.add(MessageEvent.onSubscribed(user!));
    expectLater(sut!.stream, emitsInOrder([MessageReceivedSuccess(message)]));
  });
}
