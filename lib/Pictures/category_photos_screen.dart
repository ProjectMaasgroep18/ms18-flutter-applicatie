import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Pictures/category.dart';
import 'package:ms18_applicatie/Pictures/photo_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:ms18_applicatie/Pictures/add_photo_screen.dart';
import 'package:ms18_applicatie/Pictures/photo.dart';

//Deze pagina is de photos pagina binnen een sub album .

Color mainColor = Color(0xFF15233d);

class CategoryPhotosScreen extends StatefulWidget {
  final Category category;

  const CategoryPhotosScreen({Key? key, required this.category}) : super(key: key);

  @override
  _CategoryPhotosScreenState createState() => _CategoryPhotosScreenState();
}

enum SortingOption { newest, oldest, likes }

class _CategoryPhotosScreenState extends State<CategoryPhotosScreen> {
  SortingOption _selectedOption = SortingOption.newest;

  List<Photo> _sortPhotos(List<Photo> photos) {
    switch (_selectedOption) {
      case SortingOption.newest:
        return photos.toList()..sort((a, b) => b.date.compareTo(a.date));
      case SortingOption.oldest:
        return photos.toList()..sort((a, b) => a.date.compareTo(b.date));
      case SortingOption.likes:
        return photos.toList()..sort((a, b) => b.likeCount.compareTo(a.likeCount));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title),
        actions: [
          Container(
            width: 200.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: EdgeInsets.only(right: 10),
            child: PopupMenuButton<SortingOption>(
              itemBuilder: (context) => [
                _buildSortingOption(SortingOption.newest, 'Nieuwste'),
                _buildSortingOption(SortingOption.oldest, 'Oudste'),
                _buildSortingOption(SortingOption.likes, 'Likes'),
              ],
              onSelected: (option) {
                setState(() {
                  _selectedOption = option;
                });
              },
              child: Center(
                child: Text(
                  'Sorteer op',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: widget.category.photos.length,
              itemBuilder: (context, index) {
                final photos = _sortPhotos(widget.category.photos);
                final photo = photos[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoDetailScreen(
                          photos: photos,
                          currentIndex: index,
                        ),
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
                                    Icon(Icons.thumb_up, size: 20, color: Colors.white60),
                                    SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        '${photo.likeCount} likes',
                                        style: TextStyle(fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPhotoScreen(),
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: mainColor,
        tooltip: 'Fotos toevoegen',
      ),
    );
  }

  PopupMenuItem<SortingOption> _buildSortingOption(SortingOption option, String text) {
    return PopupMenuItem<SortingOption>(
      value: option,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
