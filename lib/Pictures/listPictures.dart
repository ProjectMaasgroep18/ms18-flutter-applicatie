import 'package:flutter/material.dart';
import 'package:ms18_applicatie/menu.dart';
import 'package:ms18_applicatie/Pictures/category.dart';
import 'package:ms18_applicatie/Pictures/category_list_item.dart';
import 'package:ms18_applicatie/Pictures/photo.dart';
import 'add_category_screen.dart';
import 'package:ms18_applicatie/Pictures/add_sub_category_screen.dart';

class ListPictures extends StatefulWidget {
  const ListPictures({Key? key}) : super(key: key);

  @override
  State<ListPictures> createState() => _ListPicturesState();
}

class _ListPicturesState extends State<ListPictures> {
  final List<Category> _allCategories = [
    Category(
      title: 'Kerst eten 1',
      date: DateTime(2011, 10, 11),
      photos: [
        Photo(
          imageUrl: 'https://picsum.photos/750/300?random=1',
          title: 'Nieuwjaarsfeest',
          date: DateTime(2022, 1, 1),
          uploader: 'Geupload door: Jan Jansen',
          likeCount: 150,
          contentType: "",
        ),
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2011, 11, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
          contentType: "",
        ),
      ],
      subAlbums: [
        Category(
          title: 'Sub Album 1',
          date: DateTime(2022, 1, 1),
          photos: [
            Photo(
              imageUrl: 'https://picsum.photos/750/300?random=1',
              title: 'Nieuwjaarsfeest',
              date: DateTime(2022, 1, 1),
              uploader: 'Geupload door: Jan Jansen',
              likeCount: 150,
              contentType: "",
            ),
            Photo(
              imageUrl: 'https://picsum.photos/750/300',
              title: 'Familiediner',
              date: DateTime(2011, 11, 11),
              uploader: 'Geupload door: Rik Smits',
              likeCount: 107,
              contentType: "",
            ),
          ],
        ),
        Category(
          title: 'Sub Album 2',
          date: DateTime(2022, 2, 14),
          photos: [
            Photo(
              imageUrl: 'https://picsum.photos/750/300?random=2',
              title: 'Valentijnsdag',
              date: DateTime(2022, 2, 14),
              uploader: 'Geupload door: Piet Pietersen',
              likeCount: 200,
              contentType: "",
            ),
            Photo(
              imageUrl: 'https://picsum.photos/750/300',
              title: 'Familiediner',
              date: DateTime(2021, 11, 11),
              uploader: 'Geupload door: Rik Smits',
              likeCount: 1017,
              contentType: "",
            ),
          ],
        ),
        Category(
          title: 'Sub Album 3',
          date: DateTime(2022, 10, 11),
          photos: [
            Photo(
              imageUrl: 'https://picsum.photos/750/300',
              title: 'Familiediner',
              date: DateTime(2022, 10, 11),
              uploader: 'Geupload door: Rik Smits',
              likeCount: 1097,
              contentType: "",
            ),
            Photo(
              imageUrl: 'https://picsum.photos/750/300',
              title: 'Familiediner',
              date: DateTime(2021, 10, 11),
              uploader: 'Geupload door: Rik Smits',
              likeCount: 1087,
              contentType: "",
            ),
          ],
        ),
        Category(
          title: 'Sub Album 1',
          date: DateTime(2022, 1, 1),
          photos: [
            Photo(
              imageUrl: 'https://picsum.photos/750/300?random=1',
              title: 'Nieuwjaarsfeest',
              date: DateTime(2022, 1, 1),
              uploader: 'Geupload door: Jan Jansen',
              likeCount: 150,
              contentType: "",
            ),
            Photo(
              imageUrl: 'https://picsum.photos/750/300',
              title: 'Familiediner',
              date: DateTime(2011, 11, 11),
              uploader: 'Geupload door: Rik Smits',
              likeCount: 107,
              contentType: "",
            ),
          ],
        ),
        Category(
          title: 'Sub Album 2',
          date: DateTime(2022, 2, 14),
          photos: [
            Photo(
              imageUrl: 'https://picsum.photos/750/300?random=2',
              title: 'Valentijnsdag',
              date: DateTime(2022, 2, 14),
              uploader: 'Geupload door: Piet Pietersen',
              likeCount: 200,
              contentType: "",
            ),
            Photo(
              imageUrl: 'https://picsum.photos/750/300',
              title: 'Familiediner',
              date: DateTime(2021, 11, 11),
              uploader: 'Geupload door: Rik Smits',
              likeCount: 1017,
              contentType: "",
            ),
          ],
        ),
        Category(
          title: 'Sub Album 3',
          date: DateTime(2022, 10, 11),
          photos: [
            Photo(
              imageUrl: 'https://picsum.photos/750/300',
              title: 'Familiediner',
              date: DateTime(2022, 10, 11),
              uploader: 'Geupload door: Rik Smits',
              likeCount: 1097,
              contentType: "",
            ),
            Photo(
              imageUrl: 'https://picsum.photos/750/300',
              title: 'Familiediner',
              date: DateTime(2021, 10, 11),
              uploader: 'Geupload door: Rik Smits',
              likeCount: 1087,
              contentType: "",
            ),
          ],
        ),
      ],
    ),
    Category(
      title: 'Kerst eten 1',
      date: DateTime(2011, 10, 11),
      photos: [
        Photo(
          imageUrl: 'https://picsum.photos/750/300?random=1',
          title: 'Nieuwjaarsfeest',
          date: DateTime(2022, 1, 1),
          uploader: 'Geupload door: Jan Jansen',
          likeCount: 150,
          contentType: "",
        ),
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2011, 11, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
          contentType: "",
        ),
      ],
      subAlbums: [
        Category(
          title: 'Sub Album 1',
          date: DateTime(2022, 1, 1),
          photos: [
            Photo(
              imageUrl: 'https://picsum.photos/750/300?random=1',
              title: 'Nieuwjaarsfeest',
              date: DateTime(2022, 1, 1),
              uploader: 'Geupload door: Jan Jansen',
              likeCount: 150,
              contentType: "",
            ),
            Photo(
              imageUrl: 'https://picsum.photos/750/300',
              title: 'Familiediner',
              date: DateTime(2011, 11, 11),
              uploader: 'Geupload door: Rik Smits',
              likeCount: 107,
              contentType: "",
            ),
          ],
        ),
        Category(
          title: 'Sub Album 2',
          date: DateTime(2022, 2, 14),
          photos: [
            Photo(
              imageUrl: 'https://picsum.photos/750/300?random=2',
              title: 'Valentijnsdag',
              date: DateTime(2022, 2, 14),
              uploader: 'Geupload door: Piet Pietersen',
              likeCount: 200,
              contentType: "",
            ),
            Photo(
              imageUrl: 'https://picsum.photos/750/300',
              title: 'Familiediner',
              date: DateTime(2021, 11, 11),
              uploader: 'Geupload door: Rik Smits',
              likeCount: 1017,
              contentType: "",
            ),
          ],
        ),
        Category(
          title: 'Sub Album 3',
          date: DateTime(2022, 10, 11),
          photos: [
            Photo(
              imageUrl: 'https://picsum.photos/750/300',
              title: 'Familiediner',
              date: DateTime(2022, 10, 11),
              uploader: 'Geupload door: Rik Smits',
              likeCount: 1097,
              contentType: "",
            ),
            Photo(
              imageUrl: 'https://picsum.photos/750/300',
              title: 'Familiediner',
              date: DateTime(2021, 10, 11),
              uploader: 'Geupload door: Rik Smits',
              likeCount: 1087,
              contentType: "",
            ),
          ],
        ),
      ],
    ),
    Category(
      title: 'Kerst eten 1',
      date: DateTime(2011, 10, 11),
      photos: [
        Photo(
          imageUrl: 'https://picsum.photos/750/300?random=1',
          title: 'Nieuwjaarsfeest',
          date: DateTime(2022, 1, 1),
          uploader: 'Geupload door: Jan Jansen',
          likeCount: 150,
          contentType: "",
        ),
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2011, 11, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
          contentType: "",
        ),
      ],
      subAlbums: [
        Category(
          title: 'Sub Album 1',
          date: DateTime(2022, 1, 1),
          photos: [
            Photo(
              imageUrl: 'https://picsum.photos/750/300?random=1',
              title: 'Nieuwjaarsfeest',
              date: DateTime(2022, 1, 1),
              uploader: 'Geupload door: Jan Jansen',
              likeCount: 150,
              contentType: "",
            ),
            Photo(
              imageUrl: 'https://picsum.photos/750/300',
              title: 'Familiediner',
              date: DateTime(2011, 11, 11),
              uploader: 'Geupload door: Rik Smits',
              likeCount: 107,
              contentType: "",
            ),
          ],
        ),
        Category(
          title: 'Sub Album 2',
          date: DateTime(2022, 2, 14),
          photos: [
            Photo(
              imageUrl: 'https://picsum.photos/750/300?random=2',
              title: 'Valentijnsdag',
              date: DateTime(2022, 2, 14),
              uploader: 'Geupload door: Piet Pietersen',
              likeCount: 200,
              contentType: "",
            ),
            Photo(
              imageUrl: 'https://picsum.photos/750/300',
              title: 'Familiediner',
              date: DateTime(2021, 11, 11),
              uploader: 'Geupload door: Rik Smits',
              likeCount: 1017,
              contentType: "",
            ),
          ],
        ),
        Category(
          title: 'Sub Album 3',
          date: DateTime(2022, 10, 11),
          photos: [
            Photo(
              imageUrl: 'https://picsum.photos/750/300',
              title: 'Familiediner',
              date: DateTime(2022, 10, 11),
              uploader: 'Geupload door: Rik Smits',
              likeCount: 1097,
              contentType: "",
            ),
            Photo(
              imageUrl: 'https://picsum.photos/750/300',
              title: 'Familiediner',
              date: DateTime(2021, 10, 11),
              uploader: 'Geupload door: Rik Smits',
              likeCount: 1087,
              contentType: "",
            ),
          ],
        ),
      ],
    ),
  ];


  List<Category> _filteredCategories = [];
  TextEditingController _searchController = TextEditingController();
  int? _selectedYear;

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
          .where((category) {
        final matchesTitle = category.title.toLowerCase().contains(_searchController.text.toLowerCase());
        final matchesYear = _selectedYear == null || category.date.year == _selectedYear;
        return matchesTitle && matchesYear;
      })
          .toList();
    });
  }

  void _onYearChanged(int? year) {
    setState(() {
      _selectedYear = year;
      _performSearch();
    });
  }

  void _navigateToAddSubAlbumScreen(Category parentCategory) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddSubAlbumScreen(parentCategory: parentCategory),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<int>> yearItems = [
      DropdownMenuItem<int>(
        value: null,
        child: Text('Alle jaren'),
      ),
    ];

    final currentYear = DateTime.now().year;
    for (int year = 1923; year <= currentYear; year++) {
      yearItems.add(DropdownMenuItem<int>(
        value: year,
        child: Text(year.toString()),
      ));
    }

    return Menu(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Zoek op Albums',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _performSearch,
                    ),
                  ),
                  onSubmitted: (value) => _performSearch(),
                ),
              ),
            ),
            DropdownButton<int>(
              value: _selectedYear,
              items: yearItems,
              hint: Text("Jaar selecteren"),
              onChanged: _onYearChanged,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredCategories.length,
                itemBuilder: (context, index) {
                  return CategoryListItem(
                    category: _filteredCategories[index],
                    onDelete: () {
                      // Existing delete logic...
                    },
                    onAddSubAlbum: () => _navigateToAddSubAlbumScreen(_filteredCategories[index]),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddCategoryScreen()),
            );
          },
          child: Icon(Icons.add),
          tooltip: 'Nieuwe Album Toevoegen',
        ),
      ),
    );
  }
}
