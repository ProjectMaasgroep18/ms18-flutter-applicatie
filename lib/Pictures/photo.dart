class Photo {
  final String imageUrl;
  final String title;
  final DateTime date;
  final String uploader;
  final int likeCount;

  Photo({
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.uploader,
    required this.likeCount,
  });
}
