class Like {
   String id;
   int memberId;
   String photoId;
   DateTime likedOn;

  Like({
    required this.id,
    required this.memberId,
    required this.photoId,
    required this.likedOn,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json['id'],
      memberId: json['memberId'],
      photoId: json['photoId'],
      likedOn: DateTime.parse(json['likedOn']),
    );
  }
}