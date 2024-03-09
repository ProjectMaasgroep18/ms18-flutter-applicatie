class Photo {
  final String? id;
  final int? uploaderId;
  final DateTime uploadDate;
  late final String? title;
  final String imageBase64;
  final String contentType;
  final DateTime? takenOn;
  final String? location;
  final String? albumLocationId;
  final int likesCount;
  final bool needsApproval;

  Photo({
    this.id,
    this.uploaderId,
    required this.uploadDate,
    this.title,
    required this.imageBase64,
    required this.contentType,
    this.takenOn,
    this.location,
    this.albumLocationId,
    required this.likesCount,
    required this.needsApproval,
  });

  Photo copyWith({
    String? id,
    int? uploaderId,
    DateTime? uploadDate,
    String? title,
    String? imageBase64,
    String? contentType,
    DateTime? takenOn,
    String? location,
    String? albumLocationId,
    int? likesCount,
    bool? needsApproval,
  }) {
    return Photo(
      id: id ?? this.id,
      uploaderId: uploaderId ?? this.uploaderId,
      uploadDate: uploadDate ?? this.uploadDate,
      title: title ?? this.title,
      imageBase64: imageBase64 ?? this.imageBase64,
      contentType: contentType ?? this.contentType,
      takenOn: takenOn ?? this.takenOn,
      location: location ?? this.location,
      albumLocationId: albumLocationId ?? this.albumLocationId,
      likesCount: likesCount ?? this.likesCount,
      needsApproval: needsApproval ?? this.needsApproval,
    );
  }

  void updateTitle(String newTitle) {
    title = newTitle;
  }

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      uploaderId: json['uploaderId'],
      uploadDate: DateTime.parse(json['uploadDate']),
      title: json['title'],
      imageBase64: json['imageBase64'],
      contentType: json['contentType'],
      takenOn: json['takenOn'] != null ? DateTime.parse(json['takenOn']) : null,
      location: json['location'],
      albumLocationId: json['albumLocationId'],
      likesCount: json['likesCount'],
      needsApproval: json['needsApproval'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uploaderId': uploaderId,
      'uploadDate': uploadDate.toIso8601String(),
      'title': title,
      'imageBase64': imageBase64,
      'contentType': contentType,
      'takenOn': takenOn?.toIso8601String(),
      'location': location,
      'albumLocationId': albumLocationId,
      'likesCount': likesCount,
      'needsApproval': needsApproval,
    };
  }
}
