import 'package:flutter/material.dart';
import 'category.dart';
import 'photo_detail_screen.dart';
import 'package:intl/intl.dart';
import 'add_photo_screen.dart';
import 'package:ms18_applicatie/config.dart';

Color mainColor = Color(0xFF15233d);

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
          crossAxisCount: 2,
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
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(photo.title, overflow: TextOverflow.ellipsis),
                          SizedBox(height: 4),
                          Text(DateFormat('dd-MM-yyyy').format(photo.date), style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(photo.uploader, style: TextStyle(fontSize: 12)),
                          SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.thumb_up, size: 14, color: Colors.white),
                              SizedBox(width: 4),
                              Text('${photo.likeCount} likes', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPhotoScreen(category: category)),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: mainColor,

        tooltip: 'Foto toevoegen',
      ),

    );
  }
}
