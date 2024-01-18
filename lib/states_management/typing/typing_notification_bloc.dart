import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

part 'typing_notification_event.dart';
part 'typing_notification_state.dart';

class TypingNotificationBloc
    extends Bloc<TypingNotificationEvent, TypingNotificationState> {
  final ITypingNotificationService _typingNotification;
  StreamSubscription? _subscription;

  TypingNotificationBloc(this._typingNotification)
      : super(TypingNotificationState.initial()) {
    on<Subscribed>(_onSubscribed);
    on<_TypingNotificationReceived>(_onTypingNotificationReceived);
    on<TypingNotificationSent>(_onTypingNotificationSent);
    on<NotSubscribed>(_onNotSubscribed);
  }

  void _onSubscribed(
      Subscribed event, Emitter<TypingNotificationState> emit) async {
    if (event.usersWithChat == null) {
      add(NotSubscribed());
      return;
    }
    await _subscription?.cancel();
    _subscription = _typingNotification
        .subscribe(event.user, event.usersWithChat!)
        .listen((event) => add(_TypingNotificationReceived(event)));
  }

  void _onTypingNotificationReceived(_TypingNotificationReceived event,
      Emitter<TypingNotificationState> emit) {
    emit(TypingNotificationState.received(event.event));
  }

  void _onTypingNotificationSent(TypingNotificationSent event,
      Emitter<TypingNotificationState> emit) async {
    await _typingNotification.send(event: event.event);
    emit(TypingNotificationState.sent());
  }

  void _onNotSubscribed(
      TypingNotificationEvent event, Emitter<TypingNotificationState> emit) {
    emit(TypingNotificationState.initial());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _typingNotification.dispose();
    return super.close();
  }
}
