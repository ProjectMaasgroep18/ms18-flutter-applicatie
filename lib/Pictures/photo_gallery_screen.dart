import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Pictures/models/photo.dart';

import '../Api/apiManager.dart';
import '../config.dart';

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

    // Set reasonable default values for pagination
    const int pageNumber = 1;
    const int pageSize = 100; // Adjust based on your needs
    final String fetchUrl = 'api/photos/album/${widget.albumId}?pageNumber=$pageNumber&pageSize=$pageSize';

    try {
      // Fetch the paginated response
      final dynamic response = await ApiManager.get<dynamic>(fetchUrl, getHeaders());

      // Assuming the response is a Map with expected keys
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Album Photos"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          // Convert base64 string to bytes
          final imageBytes = base64Decode(photos[index].imageBase64);
          return Image.memory(imageBytes, fit: BoxFit.cover);
        },
      ),
    );
  }
}