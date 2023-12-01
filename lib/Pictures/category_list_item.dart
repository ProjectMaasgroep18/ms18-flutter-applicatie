import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'category.dart';
import 'category_photos_screen.dart';


class CategoryListItem extends StatelessWidget {
  final Category category;

  const CategoryListItem({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(category.date);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryPhotosScreen(category: category),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              category.title,
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
            SizedBox(height: 8.0),
            Image.network(
              category.photos.first.imageUrl,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
