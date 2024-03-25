import 'dart:convert';
import 'dart:typed_data';
import 'package:collection/collection.dart';

import '../config.dart';
import '../globals.dart';
import 'package:flutter/material.dart';
import '../Api/apiManager.dart';
import 'models/category.dart';
import 'models/photo.dart';

Color mainColor = const Color(0xFF15233d);

class PhotoDetailScreen extends StatefulWidget {
  final List<Photo> photos;
  int currentIndex;

  PhotoDetailScreen({
    super.key,
    required this.photos,
    required this.currentIndex,
  });

  @override
  _PhotoDetailScreenState createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen> {
  late PageController _controller;
  bool areDetailsAndNavBarVisible = false;
  bool isEditing = false;
  TextEditingController _titleController = TextEditingController();
  FocusNode _titleFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.currentIndex);

    // Check if the title is not null before assigning it to _titleController.text
    if (widget.photos[widget.currentIndex].title != null) {
      _titleController.text = widget.photos[widget.currentIndex].title!;
    }

    // Toegevoegd: Voeg een listener toe om de oriëntatieveranderingen te detecteren
    WidgetsBinding.instance
        .addObserver(OrientationChangeObserver(_handleOrientationChange));
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    // Toegevoegd: Verwijder de oriëntatielissener
    WidgetsBinding.instance
        .removeObserver(OrientationChangeObserver(_handleOrientationChange));
    super.dispose();
  }

  // Toegevoegd: Functie om te reageren op oriëntatieveranderingen
  void _handleOrientationChange() {
    setState(() {
      if (MediaQuery.of(context).orientation == Orientation.landscape) {
        areDetailsAndNavBarVisible = true;
      } else {
        areDetailsAndNavBarVisible = false;
      }
    });
  }

  void _toggleEdit() {
    setState(() {
      isEditing = !isEditing;
      if (isEditing) {
        // Request focus when entering editing mode
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _titleFocusNode.requestFocus();
        });
      } else {
        // Optionally, update the photo title here
        widget.photos[widget.currentIndex].updateTitle(_titleController.text);
        _updatePhoto(widget.photos[widget.currentIndex]);
      }
    });
  }

  Future<void> _updatePhoto(Photo photo) async {
    Map<String, dynamic> requestBody = {
      'AlbumLocationId': photo.albumLocationId.toString(),
      'ContentType': photo.contentType, // Assuming this is a non-nullable field
    };

    // Conditionally add other properties if they are not null.
    if (photo.title != null) requestBody['Title'] = photo.title;
    final takenOn = photo.takenOn;
    if (takenOn != null) requestBody['TakenOn'] = takenOn.toIso8601String(); // Format DateTime as ISO 8601 string
    if (photo.location != null) requestBody['Location'] = photo.location;

    try {
      await ApiManager.put('api/photos/${photo.id}', requestBody, getHeaders());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo updated successfully')));
    } catch (e) {
      print(e); // Log the error for debugging
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update photo')));
    }
  }

  Future<List<DropdownMenuItem<Category>>> buildDropdownMenuItems() async {
    final response =
        await ApiManager.get<List<dynamic>>('api/albums', getHeaders());
    final albums =
        response.map((albumJson) => Category.fromJson(albumJson)).toList();

    List<DropdownMenuItem<Category>> items = [];

    // Add the current album to items first
    if (currentAlbum != null) {
      items.add(DropdownMenuItem<Category>(
        value: currentAlbum,
        child: Text(currentAlbum!.name),
      ));
    }

    // Now find and add all parent albums
    String? currentAlbumParentId = currentAlbum?.parentAlbumId;
    while (currentAlbumParentId != null) {
      final Category? parentAlbum =
          albums.firstWhereOrNull((album) => album.id == currentAlbumParentId);
      if (parentAlbum != null) {
        items.add(DropdownMenuItem<Category>(
          value: parentAlbum,
          child: Text(parentAlbum.name),
        ));
        currentAlbumParentId = parentAlbum.parentAlbumId;
      } else {
        break; // No more parent albums
      }
    }

    return items;
  }

  void showCoverPhotoSelectionDialog() async {
    List<DropdownMenuItem<Category>> dropdownItems = await buildDropdownMenuItems();
    Category? selectedCategory = currentAlbum; // Start with the current category

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecteer Cover Photo Album'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DropdownButton<Category>(
                isExpanded: true,
                items: dropdownItems,
                onChanged: (Category? newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
                value: selectedCategory,
              );
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (selectedCategory != null) {
                  _setCoverPhoto(selectedCategory!);
                }
              },
              child: const Text('Bevestigen'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _setCoverPhoto(Category album) async {
    Map<String, dynamic> body = {
      'coverPhotoId': widget.photos[widget.currentIndex].id
    };
    body['name'] = album.name;
    body['year'] = album.year;
    body['parentAlbumId'] = album.parentAlbumId;

    String? categoryId = album.id;
    await ApiManager.put('api/albums/$categoryId', body, getHeaders());
  }

  void _toggleVisibility() {
    setState(() {
      areDetailsAndNavBarVisible = !areDetailsAndNavBarVisible;

      // Exit edit mode if details are hidden
      if (!areDetailsAndNavBarVisible && isEditing) {
        _toggleEdit();
      }
    });
  }

  Uint8List _Base64toImage(String base64string) {
    var image = Base64Decoder().convert(base64string);
    return image;
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: GestureDetector(
        onTap: () => _toggleVisibility(),
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: widget.photos.length,
              onPageChanged: (int index) {
                setState(() {
                  widget.currentIndex = index;
                  _titleController.text = widget.photos[index].title!;
                });
              },
              itemBuilder: (context, index) {
                Photo photo = widget.photos[index];
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.memory(
                    _Base64toImage(photo.imageBase64),
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
            if (areDetailsAndNavBarVisible)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AppBar(
                  title: Text(
                    widget.photos[widget.currentIndex].title?.trim().isNotEmpty == true
                        ? widget.photos[widget.currentIndex].title!
                        : 'Foto informatie',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.black.withOpacity(0.8),
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
              ),
            if (areDetailsAndNavBarVisible)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: isPortrait
                        ? _buildPortraitLayout()
                        : _buildLandscapeLayout(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortraitLayout() {
    String titleToShow = isEditing
        ? 'Wijzig Titel'
        : widget.photos[widget.currentIndex].title ?? '';

    if (titleToShow.length > 30) {
      // Truncate the title if it's longer than 30 characters
      titleToShow = '${titleToShow.substring(0, 28)}...';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              titleToShow,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Row(
              children: [
                Icon(Icons.favorite, color: Colors.red),
                SizedBox(width: 4),
                Text(
                  '${widget.photos[widget.currentIndex].likesCount}',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          'Jaar: ${widget.photos[widget.currentIndex].uploadDate.year}',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        if (isEditing)
          Column(
            children: [
              SizedBox(height: 15),
              TextField(
                controller: _titleController,
                focusNode: _titleFocusNode,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Titel',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        const SizedBox(height: 5),
        if (editPermission)
        ElevatedButton(
          onPressed: () => _toggleEdit(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
          child: Text(
            isEditing ? 'Opslaan' : 'Wijzig Titel',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        if (editPermission)
        ElevatedButton(
          onPressed: showCoverPhotoSelectionDialog, // Call the dialog function here
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
          child: const Text(
            'Stel in als Cover Photo',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout() {
    String titleToShow = isEditing
        ? 'Wijzig Titel'
        : widget.photos != null &&
                widget.photos.isNotEmpty &&
                widget.currentIndex >= 0 &&
                widget.currentIndex < widget.photos.length
            ? widget.photos[widget.currentIndex]?.title ?? ''
            : '';

    if (titleToShow.length > 43) {
      // Truncate the title if it's longer than 43 characters
      titleToShow = '${titleToShow.substring(0, 41)}...';
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                titleToShow,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Row(
              children: [
                Icon(Icons.favorite, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  '${widget.photos != null && widget.currentIndex >= 0 && widget.currentIndex < widget.photos.length ? widget.photos[widget.currentIndex]?.likesCount ?? '0' : '0'}',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            SizedBox(width: 16),
            Text(
              'Jaar: ${widget.photos != null && widget.currentIndex >= 0 && widget.currentIndex < widget.photos.length ? widget.photos[widget.currentIndex]?.uploadDate?.year.toString() ?? '' : ''}',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: () => _toggleEdit(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              child: Text(
                isEditing ? 'Opslaan' : 'Wijzig Titel',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        SizedBox(height: 0),
        if (isEditing)
          TextField(
            controller: _titleController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Titel',
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
            ),
          ),
      ],
    );
  }
}

// Toegevoegd: Observer voor oriëntatieveranderingen
class OrientationChangeObserver extends WidgetsBindingObserver {
  final Function() onOrientationChange;

  OrientationChangeObserver(this.onOrientationChange);

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    onOrientationChange();
  }
}
