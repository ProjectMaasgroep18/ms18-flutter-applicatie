import 'photo.dart';
//Deze pagina voor category model

class Category {
  final String id;
  final String name;
  final int year;
  final String? coverPhotoId;
  final String? parentAlbumId;
  final int? photoCount;
  final List<String>? childAlbumIds;

  Category({
    required this.id,
    required this.name,
    required this.year,
    this.coverPhotoId,
    this.parentAlbumId,
    this.photoCount,
    this.childAlbumIds,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      year: json['year'],
      coverPhotoId: json['coverPhotoId'],
      parentAlbumId: json['parentAlbumId'],
      photoCount: json['photoCount'],
      childAlbumIds: json['childAlbumIds'] != null ? List<String>.from(json['childAlbumIds']) : null,
    );
  }
}