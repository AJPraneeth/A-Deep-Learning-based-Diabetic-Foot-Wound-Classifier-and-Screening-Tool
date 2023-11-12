class MessageCollection {
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime sentTime;
  final MessageType messageType;

  const MessageCollection({
    required this.senderId,
    required this.receiverId,
    required this.sentTime,
    required this.content,
    required this.messageType,
  });

  factory MessageCollection.fromJson(Map<String, dynamic> json) =>
      MessageCollection(
        receiverId: json['receiverId'],
        senderId: json['senderId'],
        sentTime: json['sentTime'] != null
            ? json['sentTime'].toDate()
            : DateTime.now(),
        content: json['content'],
        messageType: MessageType.fromJson(json['messageType']),
      );

  Map<String, dynamic> toJson() => {
        'receiverId': receiverId,
        'senderId': senderId,
        'sentTime': sentTime,
        'content': content,
        'messageType': messageType.toJson(),
      };
}

enum MessageType {
  text,
  image;

  String toJson() => name;

  factory MessageType.fromJson(String json) => values.byName(json);
}
