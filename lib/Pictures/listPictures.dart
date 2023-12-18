import 'package:flutter/material.dart';
import '../menu.dart';
import 'category.dart';
import 'category_list_item.dart';
import 'photo.dart';
import 'add_category_screen.dart';
import 'package:intl/intl.dart';

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
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2019, 10, 11),
          uploader: 'Geupload door: Soumaia Mamo',
          likeCount: 107,
          contentType : "",
        ),
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2020, 11, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 117,
          contentType : "",
        ),
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2020, 10, 11),
          uploader: 'Geupload door: Soumaia Mamo',
          likeCount: 10117,
          contentType : "",
        ),
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Soumaia Mamo',
          likeCount: 10147,
          contentType : "",
        ),
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2021, 10, 11),
          uploader: 'Geupload door: Frits',
          likeCount: 1074,
          contentType : "",
        ),
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2022, 10, 11),
          uploader: 'Geupload door: Elder',
          likeCount: 1,
          contentType : "",
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
          date: DateTime(2023, 11, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
          contentType : "",
        ),
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
          contentType : "",
        ),

        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2023, 02, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
          contentType : "",
        ),

        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
          contentType : "",
        ),
      ],

    ),
    Category(
      title: 'Kerst eten 3',
      date: DateTime(2021, 10, 10),
      photos: [
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2023, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
          contentType : "",
        ),
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2022, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
          contentType : "",
        ),

        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2011, 11, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 107,
          contentType : "",
        ),
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2021, 11, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 1017,
          contentType : "",
        ),
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2022, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 1097,
          contentType : "",
        ),
        Photo(
          imageUrl: 'https://picsum.photos/750/300',
          title: 'Familiediner',
          date: DateTime(2021, 10, 11),
          uploader: 'Geupload door: Rik Smits',
          likeCount: 1087,
          contentType : "",
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
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Delete Category'),
                            content: Text('Weet u zeker dat u deze categorie wilt verwijderen? '),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Annuleren'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('verwijderen'),
                                onPressed: () {
                                  setState(() {
                                    _filteredCategories.removeAt(index);
                                    //Hier moeten we nog de categorie vanuit de database verwijderen .
                                    });


                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
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
          tooltip: 'Nieuwe Categorie Toevoegen',
        ),
      ),
    );
  }
}
