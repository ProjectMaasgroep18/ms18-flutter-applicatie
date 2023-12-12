import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'category.dart';
import 'category_photos_screen.dart';

class CategoryListItem extends StatefulWidget {
  final Category category;
  final VoidCallback onDelete;

  const CategoryListItem({
    Key? key,
    required this.category,
    required this.onDelete,
  }) : super(key: key);

  @override
  _CategoryListItemState createState() => _CategoryListItemState();
}

class _CategoryListItemState extends State<CategoryListItem> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(widget.category.date);
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryPhotosScreen(category: widget.category),
          ),
        );
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
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: widget.onDelete,
                    ),
                ],
              ),
              SizedBox(height: 8.0),

              Container(
                width: screenWidth,
                height: 300,
                child: Image.network(
                  widget.category.photos.isNotEmpty ? widget.category.photos.first.imageUrl : 'https://via.placeholder.com/150',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
