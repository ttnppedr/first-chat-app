import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final IMessageService _messageService;
  StreamSubscription? _subscription;

  MessageBloc(this._messageService) : super(MessageState.initial()) {
    on<Subscribed>(_onSubscribed);
    on<_MessageReceived>(_onMessageReceived);
    on<MessageSent>(_onMessageSent);
  }

  void _onSubscribed(Subscribed event, Emitter<MessageState> emit) async {
    await _subscription?.cancel();
    _subscription = _messageService
        .messages(activeUser: event.user)
        .listen((message) => add(_MessageReceived(message)));
  }

  void _onMessageReceived(_MessageReceived event, Emitter<MessageState> emit) {
    emit(MessageState.received(event.message));
  }

  void _onMessageSent(MessageSent event, Emitter<MessageState> emit) async {
    await _messageService.send(event.message);
    emit(MessageState.sent(event.message));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _messageService.dispose();
    return super.close();
  }
}
