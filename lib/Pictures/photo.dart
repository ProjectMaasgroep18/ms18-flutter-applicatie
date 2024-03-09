//Deze pagina is de photo model pagina ,

class Photo {
  final String id;
  final int? uploaderId;
  final DateTime uploadDate;
  final String? title;
  final String imageBase64;
  final String contentType;
  final DateTime takenOn;
  final String? location;
  final String? albumLocationId;
  final int likesCount;
  final bool needsApproval;

  Photo({
    required this.id,
    this.uploaderId,
    required this.uploadDate,
    this.title,
    required this.imageBase64,
    required this.contentType,
    required this.takenOn,
    this.location,
    this.albumLocationId,
    required this.likesCount,
    required this.needsApproval,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      uploaderId: json['uploaderId'],
      uploadDate: DateTime.parse(json['uploadDate']),
      title: json['title'],
      imageBase64: json['imageBase64'],
      contentType: json['contentType'],
      takenOn: DateTime.parse(json['takenOn']),
      location: json['location'],
      albumLocationId: json['albumLocationId'],
      likesCount: json['likesCount'],
      needsApproval: json['needsApproval'],
    );
  }
}