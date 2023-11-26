import 'package:flutter/material.dart';
import 'category.dart';
import 'photo_detail_screen.dart';
import 'package:intl/intl.dart';

class CategoryPhotosScreen extends StatelessWidget {
  final Category category;

  const CategoryPhotosScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.title),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Adjust as needed for your layout
          childAspectRatio: 1.0,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: category.photos.length,
        itemBuilder: (context, index) {
          final photo = category.photos[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoDetailScreen(photo: photo),
                ),
              );
            },
            child: GridTile(
              child: Image.network(photo.imageUrl, fit: BoxFit.cover),
              footer: GridTileBar(
                backgroundColor: Colors.black.withOpacity(0.7),
                title: Text(photo.title),
                subtitle: Text(DateFormat('dd-MM-yyyy').format(photo.date)),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        child: Icon(Icons.add),
        tooltip: 'Foto toevoegen',
      ),
    );
  }
}
