import '../../models/typing_event.dart';
import '../../models/user.dart';

abstract class ITypingNotificationService {
  Future<bool> send({required TypingEvent event, User to});
  Stream<TypingEvent> subscribe(User user, List<String> userIds);
  void dispose();
}
