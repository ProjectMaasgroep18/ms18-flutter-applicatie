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
  final List<Category> _allCategories = [
    Category(
      title: 'Kerst eten 1',
      date: DateTime(2023, 10, 10),
      photos: [
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Soumaia Mamo',
          likeCount: 107,
        ),
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
        ),
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Soumaia Mamo',
          likeCount: 107,
        ),
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Soumaia Mamo',
          likeCount: 107,
        ),
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Frits',
          likeCount: 107,
        ),
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Elder',
          likeCount: 107,
        ),


      ],
    ),
    Category(
      title: 'Kerst eten 2',
      date: DateTime(2023, 10, 10),
      photos: [
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
        ),
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
        ),

        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
        ),

        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
        ),
      ],

    ),
    Category(
      title: 'Kerst eten 3',
      date: DateTime(2023, 10, 10),
      photos: [
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
        ),
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
        ),

        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
        ),
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
        ),
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
        ),
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
        ),
      ],
    ),
  ];

  List<Category> _filteredCategories = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredCategories = _allCategories;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _filteredCategories = _allCategories;
      });
    } else {
      _performSearch();
    }
  }

  void _performSearch() {
    setState(() {
      _filteredCategories = _allCategories
          .where((category) => category.title.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Menu(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Zoek op Categories',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _performSearch,
                  ),
                ),
                onSubmitted: (value) => _performSearch(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCategories.length,
              itemBuilder: (context, index) {
                return CategoryListItem(category: _filteredCategories[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
