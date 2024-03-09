import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Pictures/models/category.dart';
import '../Api/apiManager.dart';
import '../globals.dart';
import '../config.dart';
import '../menu.dart';

class ListAlbums extends StatefulWidget {
  const ListAlbums({super.key});

  @override
  _ListAlbumsState createState() => _ListAlbumsState();
}

class _ListAlbumsState extends State<ListAlbums> {
  String displayedTitle = 'List Albums'; // Add this line
  List<Category> allCategories = [];
  bool isLoading = true;
  String? selectedParentAlbumId;

  @override
  void initState() {
    super.initState();
    fetchAlbums();
  }

  void fetchAlbums() async {
    setState(() => isLoading = true);
    try {
      final response = await ApiManager.get<List<dynamic>>(
          'api/albums', getHeaders());
      final albums = response.map((albumJson) => Category.fromJson(albumJson))
          .toList();
      setState(() {
        allCategories = albums;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching albums: $e");
      setState(() => isLoading = false);
    }
  }

  // Voeg de aangepaste functie toe
  String formatTextWithEllipsis(String input, int maxLength) {
    if (input.isEmpty) {
      return input;
    }

    List<String> words = input.split(' ');
    words.forEach((word) {
      if (word.isNotEmpty) {
        words[words.indexOf(word)] =
            word[0].toUpperCase() + word.substring(1).toLowerCase();
      }
    });

    String result = words.join(' ');

    if (result.length > maxLength) {
      result = result.substring(0, maxLength - 3) + '...';
    }

    return result;
  }


  Future<void> showDeleteConfirmationDialog(String albumTitle, String albumId,
      int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Bevestig Verwijdering',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle
                        .of(context)
                        .style,
                    children: <TextSpan>[
                      TextSpan(text: 'Weet je zeker dat je '),
                      TextSpan(text: formatTextWithEllipsis(albumTitle, 20),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' en alle onderliggende onderdelen wilt '),
                      TextSpan(text: 'verwijderen',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '?'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ja'),
              onPressed: () {
                deleteAlbum(albumId, index);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Nee'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void deleteAlbum(String albumId, int index) {
    try {
      ApiManager.delete('api/albums/$albumId', getHeaders());
      setState(() => allCategories.removeAt(index));
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Album successfully deleted")));
    } catch (e) {
      print("Error deleting album: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error deleting album: $e")));
    }
  }


  void addCategory() {
    TextEditingController nameController = TextEditingController();
    TextEditingController yearController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Add Category'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController,
                    decoration: InputDecoration(hintText: 'Name')),
                TextField(controller: yearController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Year (Optional)')),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel')),
              TextButton(
                onPressed: () async {
                  await postCategory(nameController.text, yearController.text);
                  Navigator.of(context).pop();
                },
                child: Text('Add'),
              ),
            ],
          ),
    );
  }

  String formatText(String input) {
    if (input.isEmpty) {
      return input;
    }

    List<String> words = input.split(' ');
    words.forEach((word) {
      if (word.isNotEmpty) {
        words[words.indexOf(word)] =
            word[0].toUpperCase() + word.substring(1).toLowerCase();
      }
    });

    return words.join(' ');
  }

  Future<void> postCategory(String name, String year) async {
    try {
      String formattedName = formatText(name);

      Map<String, dynamic> body = {
        'name': formattedName,
      };

      if (year.isNotEmpty) {
        body['year'] = int.tryParse(year);
      }

      if (currentAlbum != null) {
        body['parentAlbumId'] = currentAlbum;
      }

      await ApiManager.post('api/albums', body, getHeaders());
      fetchAlbums(); // Refresh the albums/categories list
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Category added successfully')),
      );
    } catch (e) {
      print('Error adding category: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding category: $e')),
      );
    }
  }

  void editAlbum(BuildContext context, Category category, int index) {
    TextEditingController nameController = TextEditingController(
        text: category.name);
    TextEditingController yearController = TextEditingController(
        text: category.year?.toString() ?? '');

    // Temporary variable to hold the selected value inside the dialog
    String? tempSelectedParentAlbumId = category.parentAlbumId;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Album'),
          content: StatefulBuilder( // This widget allows the dialog itself to be stateful
            builder: (BuildContext context, StateSetter setStateDialog) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: nameController,
                        decoration: InputDecoration(hintText: 'Name')),
                    TextField(controller: yearController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: 'Year (Optional)')),
                    DropdownButton<String>(
                      value: tempSelectedParentAlbumId,
                      isExpanded: true,
                      hint: Text("Select Parent Album"),
                      onChanged: (value) {
                        setStateDialog(() { // Use setStateDialog to update the dialog's state
                          tempSelectedParentAlbumId = value;
                        });
                      },
                      items: [
                        DropdownMenuItem<String>(
                          value: null, // This represents the "None" option
                          child: Text("None"),
                        ),
                        ...allCategories.where((c) =>
                        c.id != category.id && (c.photoCount ?? 0) == 0).map<
                            DropdownMenuItem<
                                String>>((Category category) {
                          return DropdownMenuItem<String>(
                            value: category.id,
                            child: Text(category.name),
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Update the main state with the new selection after closing the dialog
                setState(() {
                  selectedParentAlbumId = tempSelectedParentAlbumId;
                });
                await updateCategory(
                    category.id, nameController.text, yearController.text,
                    tempSelectedParentAlbumId);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateCategory(String id, String name, String year,
      String? parentAlbumId) async {
    try {
      Map<String, dynamic> body = {'name': name};
      if (year.isNotEmpty) body['year'] = int.tryParse(year);
      if (parentAlbumId != null) body['parentAlbumId'] = parentAlbumId;

      await ApiManager.put('api/albums/$id', body, getHeaders());
      fetchAlbums(); // Refresh the albums/categories list
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Album updated successfully')));
    } catch (e) {
      print('Error updating album: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating album: $e')));
    }
  }


  void goBackToParentAlbum() {
    if (currentAlbum == null) {
      // At the root level, no parent exists
      return;
    }

    Category? currentCategory;
    try {
      // Attempt to find the current album in the allCategories list
      currentCategory = allCategories.firstWhere((category) => category.id == currentAlbum);
    } catch (e) {
      // If the album is not found, an exception will be caught, and currentCategory will remain null
      currentAlbum = null;
    }

    setState(() {
      // If an album is found, set currentAlbum to its parentAlbumId. Otherwise, set currentAlbum to null.
      currentAlbum = currentCategory?.parentAlbumId ?? null;
      fetchAlbums(); // Refresh the list based on the new currentAlbum
    });

    // Update the displayed title after the state is updated
    if (currentAlbum != null) {
      setState(() {
        displayedTitle = allCategories
            .firstWhere((category) => category.id == currentAlbum)
            .name;
      });
    } else {
      setState(() {
        displayedTitle = 'List Albums';
      });
    }
  }


  void onAlbumClicked(Category album) {
    setState(() {
      displayedTitle = album.name;
      currentAlbum = album.id;
      fetchAlbums();
    });
  }



  @override
  Widget build(BuildContext context) {
    List<Category> filteredCategories = allCategories
        .where((album) => album.parentAlbumId == currentAlbum)
        .toList();

    return Menu(
      title: Text(
        'Albums',
        style: TextStyle(color: Colors.white),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            displayedTitle,
            style: currentAlbum == null
                ? TextStyle(fontWeight: FontWeight.normal)  // Main screen title style
                : TextStyle(fontWeight: FontWeight.bold),  // Sub-album title style
          ),
          leading: currentAlbum != null
              ? IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: goBackToParentAlbum,
          )
              : null,
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: filteredCategories.length,
          itemBuilder: (context, index) {
            final category = filteredCategories[index];
            String formattedAlbumName = formatText(category.name);

            final maxLength = 20;
            if (formattedAlbumName.length > maxLength) {
              formattedAlbumName =
                  formattedAlbumName.substring(0, maxLength - 2) + '...';
            }

            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () => onAlbumClicked(category),
                    child: category.coverPhotoId != null
                        ? Image.asset(
                      'assets/photos/${category.coverPhotoId}',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                        : Image.asset(
                      'assets/photos/folderIcon.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.7),
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        formattedAlbumName,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    child: Container(
                      padding: EdgeInsets.all(0.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0.0),
                          bottomRight: Radius.circular(0.0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            iconSize: 20.0,
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () =>
                                editAlbum(context, category, index),
                          ),
                          SizedBox(
                            width: 0.0,
                          ),
                          IconButton(
                            iconSize: 20.0,
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                showDeleteConfirmationDialog(
                                    category.name, category.id, index),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addCategory,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}