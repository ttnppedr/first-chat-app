import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

part 'receipt_event.dart';
part 'receipt_state.dart';

class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  final IReceiptService _receiptService;
  StreamSubscription? _subscription;

  ReceiptBloc(this._receiptService) : super(ReceiptState.initial()) {
    on<Subscribed>(_onSubscribed);
    on<_ReceiptReceived>(_onReceiptReceived);
    on<ReceiptSent>(_onReceiptSent);
  }

  void _onSubscribed(Subscribed event, Emitter<ReceiptState> emit) async {
    await _subscription?.cancel();
    _subscription = _receiptService
        .receipts(event.user)
        .listen((message) => add(_ReceiptReceived(message)));
  }

  void _onReceiptReceived(_ReceiptReceived event, Emitter<ReceiptState> emit) {
    emit(ReceiptState.received(event.message));
  }

  void _onReceiptSent(ReceiptSent event, Emitter<ReceiptState> emit) async {
    await _receiptService.send(event.receipt);
    emit(ReceiptState.sent(event.receipt));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _receiptService.dispose();
    return super.close();
  }
}
