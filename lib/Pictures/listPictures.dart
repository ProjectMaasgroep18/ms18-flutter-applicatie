import 'package:flutter/material.dart';
import '../menu.dart';
import 'category.dart';
import 'category_list_item.dart';
import 'photo.dart';

class ListPictures extends StatefulWidget {
  const ListPictures({Key? key}) : super(key: key);

  @override
  State<ListPictures> createState() => _ListPicturesState();
}

class _ListPicturesState extends State<ListPictures> {
  final List<Category> categories = [
    Category(
      title: 'Kerst eten',
      date: DateTime(2023, 10, 10),
      photos: [
        Photo(
          imageUrl: 'https://picsum.photos/200/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Soumaia Mamo',
          likeCount: 107,
        ),
        Photo(
          imageUrl: 'https://picsum.photos/200/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
        ),
        Photo(
          imageUrl: 'https://picsum.photos/200/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Soumaia Mamo',
          likeCount: 107,
        ),
        Photo(
          imageUrl: 'https://picsum.photos/200/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Soumaia Mamo',
          likeCount: 107,
        ),
        Photo(
          imageUrl: 'https://picsum.photos/200/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Frits',
          likeCount: 107,
        ),
        Photo(
          imageUrl: 'https://picsum.photos/200/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Elder',
          likeCount: 107,
        ),


      ],
    ),
    Category(
      title: 'Kerst eten',
      date: DateTime(2023, 10, 10),
      photos: [
        Photo(
          imageUrl: 'https://picsum.photos/200/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
        ),
        Photo(
          imageUrl: 'https://picsum.photos/200/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
        ),

        Photo(
          imageUrl: 'https://picsum.photos/200/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
        ),

        Photo(
          imageUrl: 'https://picsum.photos/200/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
        ),
      ],

    ),
    Category(
      title: 'Kerst avond',
      date: DateTime(2023, 10, 10),
      photos: [
        Photo(
          imageUrl: 'https://picsum.photos/200/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
        ),
        Photo(
          imageUrl: 'https://picsum.photos/200/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
        ),

        Photo(
          imageUrl: 'https://picsum.photos/200/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
        ),
        Photo(
          imageUrl: 'https://picsum.photos/200/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
        ),
        Photo(
          imageUrl: 'https://picsum.photos/200/300',
          title: 'Kerst avond',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
        ),
        Photo(
          imageUrl: 'https://picsum.photos/200/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Menu(
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return CategoryListItem(category: categories[index]);
        },
      ),
    );
  }
}
