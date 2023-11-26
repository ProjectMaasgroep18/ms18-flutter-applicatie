import 'photo.dart';

class Category {
  final String title;
  final DateTime date;
  final List<Photo> photos;

  Category({
    required this.title,
    required this.date,
    required this.photos,
  });
}
