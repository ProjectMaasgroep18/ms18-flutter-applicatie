import 'package:flutter/material.dart';
import '../Pictures/models/category.dart';
import '../Api/apiManager.dart';
import '../globals.dart';
import '../config.dart';

class ListAlbums extends StatefulWidget {
  const ListAlbums({super.key});

  @override
  _ListAlbumsState createState() => _ListAlbumsState();
}

class _ListAlbumsState extends State<ListAlbums> {
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

  void deleteAlbum(String albumId, int index) async {
    try {
      await ApiManager.delete('api/albums/$albumId', getHeaders());
      setState(() => allCategories.removeAt(index));
      fetchAlbums();
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

  Future<void> postCategory(String name, String year) async {
    try {
      Map<String, dynamic> body = {
        'name': name,
      };

      if (year.isNotEmpty) {
        body['year'] = int.tryParse(year);
      }

      // Only add parentAlbumId to the JSON body if it's not null
      if (currentAlbum != null) {
        body['parentAlbumId'] = currentAlbum;
      }

      await ApiManager.post('api/albums', body, getHeaders());
      fetchAlbums(); // Refresh the list of albums/categories
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category added successfully')));
    } catch (e) {
      print('Error adding category: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding category: $e')));
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
      currentAlbum = currentCategory?.parentAlbumId;
      fetchAlbums(); // Refresh the list based on the new currentAlbum
    });
  }

  void onAlbumClicked(Category album) {
    setState(() {
      currentAlbum = album.id; // Navigate into the clicked album
    });

  }

  @override
  Widget build(BuildContext context) {
    List<Category> filteredCategories = allCategories.where((album) =>
    album.parentAlbumId == currentAlbum).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('List Albums'),
        leading: currentAlbum != null ? IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => goBackToParentAlbum(),
        ) : null,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: filteredCategories.length,
        itemBuilder: (context, index) {
          final category = filteredCategories[index];
          return ListTile(
            leading: category.coverPhotoId != null ? Image.asset(
                'assets/photos/${category.coverPhotoId}') : Image.asset(
                'assets/photos/folderIcon.png'),
            title: Text(category.name),
            subtitle: Text('Photos: ${category.photoCount ?? 0}'),
            onTap: () => onAlbumClicked(category),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => editAlbum(context, category, index),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteAlbum(category.id, index),
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
    );
  }
}

