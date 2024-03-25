class Category {
  String id;
   String name;
   int? year;
   String? coverPhotoId;
   String? parentAlbumId;
   int? photoCount;

  Category({
    required this.id,
    required this.name,
    this.year,
    this.coverPhotoId,
    this.parentAlbumId,
    this.photoCount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      year: json['year'],
      coverPhotoId: json['coverPhotoId'],
      parentAlbumId: json['parentAlbumId'],
      photoCount: json['photoCount'],
    );
  }

  Category copyWith({
    String? id,
    String? name,
    int? year,
    String? coverPhotoId,
    String? parentAlbumId,
    int? photoCount,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      year: year ?? this.year,
      coverPhotoId: coverPhotoId ?? this.coverPhotoId,
      parentAlbumId: parentAlbumId ?? this.parentAlbumId,
      photoCount: photoCount ?? this.photoCount,
    );
  }
}
