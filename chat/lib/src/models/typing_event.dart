enum Typing { start, stop }

extension TypingParsing on Typing {
  String value() {
    return this.toString().split('.').last;
  }

  static Typing fromString(String? status) {
    return Typing.values.firstWhere((element) => element.value() == status);
  }
}

class TypingEvent {
  String? get id => _id;
  final String? from;
  final String? to;
  final Typing event;
  String? _id;

  TypingEvent({required this.from, required this.to, required this.event});

  Map<String, dynamic> toJson() => {
        'from': from,
        'to': to,
        'event': event.value(),
      };

  factory TypingEvent.fromJson(Map<String, dynamic> json) {
    final event = TypingEvent(
      from: json['from'],
      to: json['to'],
      event: TypingParsing.fromString(json['event']),
    );
    event._id = json['id'];
    return event;
  }
}
