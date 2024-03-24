class Like {
  final String id;
  final int memberId;
  final String photoId;
  final DateTime likedOn;

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