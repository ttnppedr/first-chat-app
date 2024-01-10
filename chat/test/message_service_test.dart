import 'package:chat/src/models/message.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/message/message_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

import 'helpers.dart';

void main() {
  RethinkDb r = RethinkDb();
  Connection? connection;
  late MessageService sut;

  setUp(() async {
    connection = await r.connect(host: "127.0.0.1", port: 28015);
    await createDb(r, connection!);
    sut = MessageService(r, connection);
  });

  tearDown(() async {
    sut.dispose();
    await cleanDb(r, connection!);
  });

  final user = User.fromJson({
    'id': '1234',
    'active': true,
    'lastseen': DateTime.now(),
  });

  final user2 = User.fromJson({
    'id': '1111',
    'active': true,
    'lastseen': DateTime.now(),
  });

  test('sent message successfully', () async {
    Message message = Message(
        from: user.id,
        to: user2.id,
        timestamp: DateTime.now(),
        contents: 'this is a message');

    final res = await sut.send(message);

    expect(res, true);
  });

  test('successfully subscribe and receive messages', () async {
    sut.messages(activeUser: user2).listen(expectAsync1((message) {
          expect(message.to, user2.id);
          expect(message.id, isNotEmpty);
        }, count: 2));

    Message message = Message(
      from: user.id,
      to: user2.id,
      timestamp: DateTime.now(),
      contents: 'this is a message',
    );

    Message secondMessage = Message(
      from: user.id,
      to: user2.id,
      timestamp: DateTime.now(),
      contents: 'this is another message',
    );

    await sut.send(message);
    await sut.send(secondMessage);
  });

  test('successfully subscribe and receive messages', () async {
    Message message = Message(
      from: user.id,
      to: user2.id,
      timestamp: DateTime.now(),
      contents: 'this is a message',
    );

    Message secondMessage = Message(
      from: user.id,
      to: user2.id,
      timestamp: DateTime.now(),
      contents: 'this is another message',
    );

    await sut.send(message);
    await sut.send(secondMessage).whenComplete(
        () => sut.messages(activeUser: user2).listen(expectAsync1((message) {
              expect(message.to, user2.id);
            }, count: 2)));
  });
}