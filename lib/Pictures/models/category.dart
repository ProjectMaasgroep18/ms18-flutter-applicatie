class Category {
  final String id;
  final String name;
  final int? year;
  final String? coverPhotoId;
  final String? parentAlbumId;
  final int? photoCount;

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
}