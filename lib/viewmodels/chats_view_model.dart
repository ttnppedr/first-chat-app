import 'package:chat/chat.dart';
import 'package:first_chat_app/models/local_message.dart';
import 'package:first_chat_app/viewmodels/base_view_model.dart';

import '../data/datasources/datasource_contract.dart';

class ChatsViewModel extends BaseViewModel {
  IDatasource _datasource;

  ChatsViewModel(this._datasource) : super(_datasource);

  Future<void> receiveMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.from, message, ReceiptStatus.delivered);
    await addMessage(localMessage);
  }
}
