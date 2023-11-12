class MessageUserCollection {
  final String uid;
  final String name;
  final String email;
  //final String image;
  final DateTime lastActive;
  final bool isOnline;

  const MessageUserCollection({
    required this.name,
    // required this.image,
    required this.lastActive,
    required this.uid,
    required this.email,
    this.isOnline = false,
  });

  factory MessageUserCollection.fromJson(Map<String, dynamic> json) =>
      MessageUserCollection(
        uid: json['uid'],
        name: json['name'],
        //image: json['image'],
        email: json['email'],
        isOnline: json['isOnline'] ?? false,
        lastActive: json['lastActive'].toDate(),
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        //'image': image,
        'email': email,
        'isOnline': isOnline,
        'lastActive': lastActive,
      };
}
