import 'package:flutter/material.dart';
import 'category.dart';
import 'category_photos_screen.dart';
import 'category_service.dart';
import 'category_list_item.dart';

class ListPictures extends StatefulWidget {
  const ListPictures({Key? key}) : super(key: key);

  @override
  _ListPicturesState createState() => _ListPicturesState();
}

class _ListPicturesState extends State<ListPictures> {
  late Future<List<Category>> _categories;

  @override
  void initState() {
    super.initState();
    _categories = CategoryService.getCategoriesWithNullParentId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Albums'),
      ),
      body: FutureBuilder<List<Category>>(
        future: _categories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred!'));
          } else if (snapshot.hasData) {
            final categories = snapshot.data!;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryListItem(category: category, onTap: () => _onCategoryTap(context, category), onDelete: () {  }, onAddSubAlbum: () {  },);
              },
            );
          } else {
            return Center(child: Text('No albums found'));
          }
        },
      ),
    );
  }

  void _onCategoryTap(BuildContext context, Category category) {
    if (category.photoCount != 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPhotosScreen(category: category)));
    } else {
      setState(() {
        _categories = CategoryService.getSubCategories(category.id);
      });
    }
  }
}
