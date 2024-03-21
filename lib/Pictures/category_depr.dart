import 'photo_depr.dart';
//Deze pagina voor category model

class Category {
  String title;
  DateTime date;
  List<Photo> photos;
  List<Category> subAlbums;

  Category({
    required this.title,
    required this.date,
    this.photos = const [],
    this.subAlbums = const [],
  });
}
