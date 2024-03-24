import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Pictures/models/photo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ms18_applicatie/config.dart';
import '../menu.dart';

Color mainColor = Color(0xFF15233d);

class PhotoDetailScreen extends StatefulWidget {
  final List<Photo> photos;
  final int currentIndex;

  PhotoDetailScreen({
    Key? key,
    required this.photos,
    required this.currentIndex,
  }) : super(key: key);

  @override
  _PhotoDetailScreenState createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen> {
  late PageController _controller;
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.currentIndex);
    _titleController = TextEditingController(text: widget.photos[widget.currentIndex].title);
  }

  Future<void> _saveTitle(Photo photo, String newTitle) async {
    print('Attempting to save title...');
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:5032/api/photos/${photo.id}'),
        headers: getHeaders(),
        body: jsonEncode({
          'title': newTitle,
          'contentType': 'image/jpeg',
          'takenOn': photo.takenOn?.toIso8601String(),
          'location': photo.location,
          'albumLocationId': photo.albumLocationId,
          'needsApproval': photo.needsApproval,
        }),
      );
      print('Status code: ${response.statusCode}');
      if (response.statusCode == 204) {
        print("Title updated successfully");
        setState(() {
          final photoIndex = widget.photos.indexWhere((p) => p.id == photo.id);
          if (photoIndex != -1) {
            widget.photos[photoIndex] = widget.photos[photoIndex].copyWith(title: newTitle);
          } else {
            print('Photo with id ${photo.id} not found in the list');
          }
        });
      } else {
        print("Failed to update title: ${response.body}");
      }
    } catch (e) {
      print("Error while saving title: $e");
    }
  }

  Future<void> _deletePhoto(String photoId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:5032/api/photos/$photoId'),
        headers: getHeaders(),
      );

      if (response.statusCode == 204) {
        print('Photo deleted successfully');
        Navigator.of(context).pop();
      } else {
        print('Failed to delete photo: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting photo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building widget with currentIndex: ${widget.currentIndex}');
    return Menu(
        title: Text(
          'Foto informatie',
          style: TextStyle(color: Colors.white),
        ),
        child: Scaffold(
        appBar: AppBar(
        title: Text('Foto informatie'),
    ),
    body: Stack(
    children: [
    PageView.builder(
    controller: _controller,
    itemCount: widget.photos.length,
    onPageChanged: (int index) {
    setState(() {
    _titleController.text = widget.photos[index].title ?? '';
    });
    },
    itemBuilder: (context, index) {
    Photo photo = widget.photos[index];
    return SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    children: [
    Stack(
    alignment: Alignment.center,
    children: [
    Container(
    width: MediaQuery.of(context).size.width * 1,
    height: MediaQuery.of(context).size.height * 0.45,
    child: Image.memory(
    base64Decode(photo.imageBase64),
    fit: BoxFit.cover,
    ),
    ),
    Positioned(
    left: 0,
    child: index > 0
    ? Container(
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.white.withOpacity(0.5),
    ),
    child: IconButton(
    icon: Icon(Icons.arrow_back_ios, size: 40, color: mainColor),
    onPressed: () {
    _controller.previousPage(
    duration: Duration(milliseconds: 300),
    curve: Curves.easeInOut,
    );
    },
    ),
    )
        : SizedBox(),
    ),
    Positioned(
    right: 0,
    child: index < widget.photos.length - 1
    ? Container(
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.white.withOpacity(0.5),
    ),
    child: IconButton(
    icon: Icon(Icons.arrow_forward_ios, size: 40, color: mainColor),
    onPressed: () {
    _controller.nextPage(
    duration: Duration(milliseconds: 300),
    curve: Curves.easeInOut,
    );
    },
    ),
    )
        : SizedBox(),
    ),
    Positioned(
    bottom: 16,
    child: Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
    color: Colors.grey[200]!.withOpacity(0.5),
    borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
    'Likes: ${photo.likesCount}',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    ),
    ),
    ],
    ),
    SizedBox(height: 16),
    Padding(
    padding: const EdgeInsets.only(top: 16.0),
    child: TextField(
    controller: _titleController,
    decoration: InputDecoration(
    labelText: 'Titel',
    border: OutlineInputBorder(),
    ),
    ),
    ),
    SizedBox(height: 10),
    SizedBox(
    width: 200,
    child: ElevatedButton(
    onPressed: () async {
    print('Opslaan button pressed with title: ${_titleController.text}');
    if (photo.id != null) {
    await _saveTitle(photo, _titleController.text);

    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    backgroundColor: Colors.green,
    content: Text(
    'De title is gewijzigd',
    style: TextStyle(color: Colors.white),
    ),
    ),
    );

    Navigator.of(context).pop();
    Navigator.of(context).pop();
    } else {
    print('Error: Photo ID is null');
    }
    },
    style: ElevatedButton.styleFrom(
    backgroundColor: mainColor,
    ),
    child: Text('Title wijzigen', style: TextStyle(color: Colors.white)),
    ),
    ),
    SizedBox(height: 10),
    SizedBox(
    width: 200,
    child: ElevatedButton(
    onPressed: () async {
    print('Delete button pressed');
    if (photo.id != null) {
    await _deletePhoto(photo.id!);

    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    backgroundColor: Colors.green,
    content: Text(
    'De foto is verwijderd',
    style: TextStyle(color: Colors.white),
    ),
    ),
    );

    Navigator.of(context).pop();
    } else {
      print('Error: Photo ID is null');
    }
    },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: Text('Foto verwijderen', style: TextStyle(color: Colors.white)),
    ),
    ),
      SizedBox(height: 10),
      SizedBox(
        width: 200,
        child: ElevatedButton(
          onPressed: () {
            print('Terug button pressed');
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
          child: Text('Terug', style: TextStyle(color: Colors.white)),
        ),
      ),
    ],
    ),
    ),
    );
    },
    ),
    ],
    ),
        ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    super.dispose();
  }
}

