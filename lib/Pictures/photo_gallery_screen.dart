import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Pictures/models/photo.dart';
import '../Api/apiManager.dart';
import '../config.dart';
import 'photo_detail_screen.dart';
import 'dart:convert';
import '../menu.dart'; // Importeer de Menu-widget

class PhotoGalleryScreen extends StatefulWidget {
  final String albumId;

  const PhotoGalleryScreen({Key? key, required this.albumId}) : super(key: key);

  @override
  _PhotoGalleryScreenState createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<PhotoGalleryScreen> {
  List<Photo> photos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPhotos();
  }

  void fetchPhotos() async {
    setState(() => isLoading = true);

    const int pageNumber = 1;
    const int pageSize = 100;
    final String fetchUrl = 'api/photos/album/${widget.albumId}?pageNumber=$pageNumber&pageSize=$pageSize';

    try {
      final response = await ApiManager.get<dynamic>(fetchUrl, getHeaders());
      if (response is Map<String, dynamic>) {
        final List<dynamic> items = response['items'] ?? [];
        final List<Photo> photos = items.map((item) => Photo.fromJson(item)).toList();

        setState(() {
          this.photos = photos;
          isLoading = false;
        });
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (e) {
      print("Error fetching photos: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Menu( // Voeg de Menu-widget toe
      title: Text(
        'Album Photos',
        style: TextStyle(color: Colors.white),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Lijst met fotos"),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: photos.length,
          itemBuilder: (context, index) {
            final imageBytes = base64Decode(photos[index].imageBase64);
            return InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoDetailScreen(
                    photos: photos,
                    currentIndex: index,
                  ),
                ),
              ),
              child: Image.memory(imageBytes, fit: BoxFit.cover),
            );
          },
        ),
      ),
    );
  }
}
