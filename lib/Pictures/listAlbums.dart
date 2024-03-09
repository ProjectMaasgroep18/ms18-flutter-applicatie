import 'package:flutter/material.dart';
import '../Pictures/models/category.dart';
import '../Api/apiManager.dart';
import '../globals.dart';
import '../config.dart';

class ListAlbums extends StatefulWidget {
  const ListAlbums({super.key});

  @override
  _ListAlbumsState createState() => _ListAlbumsState();
}

class _ListAlbumsState extends State<ListAlbums> {
  List<Category> allCategories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAlbums();
  }

  void fetchAlbums() async {
    try {
        Map<String, String> headers = getHeaders();

      final response = await ApiManager.get<List<dynamic>>('api/albums', headers);

      final albums = response.map((albumJson) => Category.fromJson(albumJson as Map<String, dynamic>)).toList() ?? [];

      setState(() {
        allCategories = albums;
        isLoading = false; // Data fetched, loading complete
      });
    } catch (e) {
      print("Error fetching albums: $e");
      setState(() {
        isLoading = false; // An error occurred, mark loading as complete to update the UI accordingly
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Albums'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
          : ListView.builder(
        itemCount: allCategories.length,
        itemBuilder: (context, index) {
          Category category = allCategories[index];
          return ListTile(
            leading: category.coverPhotoId != null
                ? Image.asset('assets/photos/${category.coverPhotoId}') // Dynamically load image from assets
                : Image.asset('assets/photos/folderIcon.png'), // Placeholder image
            title: Text(category.name),
            subtitle: Text('Photos: ${category.photoCount ?? 0}'),
          );
        },
      ),
    );
  }
}
