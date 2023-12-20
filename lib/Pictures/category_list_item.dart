import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'category.dart';
import 'category_photos_screen.dart';
import 'add_sub_category_screen.dart';

class CategoryListItem extends StatefulWidget {
  final Category category;
  final VoidCallback onDelete;
  final VoidCallback onAddSubAlbum;

  const CategoryListItem({
    Key? key,
    required this.category,
    required this.onDelete,
    required this.onAddSubAlbum,
  }) : super(key: key);

  @override
  _CategoryListItemState createState() => _CategoryListItemState();
}

class _CategoryListItemState extends State<CategoryListItem> {
  bool isHovering = false;
  bool isExpanded = false;


  void _deleteSubAlbum(int subAlbumIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Sub Album'),
          content: Text('Weet u zeker dat u dit sub album wilt verwijderen?'),
          actions: <Widget>[
            TextButton(
              child: Text('Annuleren'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Verwijderen'),
              onPressed: () {
                setState(() {
                  widget.category.subAlbums.removeAt(subAlbumIndex);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteAlbum() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Album verwijderen'),
          content: Text('Weet u zeker dat u dit album wilt verwijderen?'),
          actions: <Widget>[
            TextButton(
              child: Text('Annuleren'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Verwijderen'),
              onPressed: () {
                widget.onDelete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddSubAlbumScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddSubAlbumScreen(parentCategory: widget.category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(widget.category.date);
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        InkWell(
          onTap: () {
            if (widget.category.subAlbums.isNotEmpty) {
              setState(() {
                isExpanded = !isExpanded;
              });
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryPhotosScreen(category: widget.category),
                ),
              );
            }
          },
          child: MouseRegion(
            onEnter: (_) => setState(() => isHovering = true),
            onExit: (_) => setState(() => isHovering = false),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.category.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isHovering)
                        Row(
                          children: [
                            Center(
                              child: Tooltip(
                                message: "Sub album toevoegen",
                                child: IconButton(
                                  icon: Icon(Icons.add, size: 24, color: Colors.green),
                                  onPressed: _navigateToAddSubAlbumScreen,
                                ),
                              ),
                            ),
                            Tooltip(
                              message: "Album verwijderen",
                              child: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: _confirmDeleteAlbum,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  if (widget.category.photos.isNotEmpty)
                    Container(
                      width: screenWidth,
                      height: 300,
                      child: Image.network(
                        widget.category.photos.first.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: Container(),
          secondChild: Container(
            padding: EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildSubAlbumList(),
            ),
          ),
          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 500),
        ),
      ],
    );
  }

  List<Widget> _buildSubAlbumList() {
    return widget.category.subAlbums.asMap().entries.map((entry) {
      int idx = entry.key;
      Category subAlbum = entry.value;

      return ListTile(
        title: Text(subAlbum.title),
        trailing: Tooltip(
          message: "Sub album verwijderen",
          child: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteSubAlbum(idx),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryPhotosScreen(category: subAlbum),
            ),
          );
        },
      );
    }).toList();
  }
}

