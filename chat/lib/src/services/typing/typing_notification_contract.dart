import '../../models/typing_event.dart';
import '../../models/user.dart';

abstract class ITypingNotificationService {
  Future<bool> send({required TypingEvent event});
  Stream<TypingEvent> subscribe(User user, List<String> userIds);
  void dispose();
}
