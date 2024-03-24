import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ms18_applicatie/Api/apiManager.dart'; // Assuming you have this path

import '../config.dart';
import '../globals.dart';
import 'listAlbums.dart';

class AddPictureScreen extends StatefulWidget {
  const AddPictureScreen({super.key});

  @override
  _AddPictureScreenState createState() => _AddPictureScreenState();
}

class _AddPictureScreenState extends State<AddPictureScreen> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _selectedImages;
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _selectedImages = images;
      });
    }
  }

  Future<void> _takePicture() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _selectedImages = [photo];
      });
    }
  }

  Future<String> _imageToBase64(String imagePath) async {
    File imageFile = File(imagePath);
    List<int> imageBytes = await imageFile.readAsBytes();
    try {
      return base64Encode(imageBytes);
    } catch (e) {
      print('Error encoding image: $e');
      return '';
    }
  }

  Future<void> _uploadImages() async {
    if (_selectedImages == null) return;
    var uploadSuccessful = true;

    for (var image in _selectedImages!) {
      String imageBase64 = await _imageToBase64(image.path);

      // Start with mandatory fields
      Map<String, dynamic> photoJson = {
        "ImageData": imageBase64,
        "ContentType": "image/jpeg",
      };

      // Conditionally add title if it is not empty
      if (_titleController.value.text.isNotEmpty) {
        photoJson["title"] = _titleController.text;
      }

      // Conditionally add albumId if it is not null
      if (currentAlbum != null) {
        photoJson["albumId"] = currentAlbum!.id;
      }

      // Here we assume ApiManager has a static method called post that takes the endpoint, the body, and headers
      try {
        await ApiManager.post('api/photos', photoJson, getHeaders());
      } catch (e) {
        uploadSuccessful = false;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload image: $e')));
      }
    }

    if (uploadSuccessful) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All images uploaded successfully')));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Picture'),
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickImages,
              child: const Text('Select Images from Gallery'),
            ),
            ElevatedButton(
              onPressed: _takePicture,
              child: const Text('Take a Picture'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0), // Add padding for better UI
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
            ),
            ElevatedButton(
              onPressed: _uploadImages,
              child: const Text('Upload'),
            ),
            _selectedImages != null &&
                    _selectedImages!.isNotEmpty // Conditional rendering
                ? SizedBox(
                    height: 300, // Specify a height for the container
                    child: GridView.builder(
                      shrinkWrap: true,
                      // Add shrinkWrap
                      physics: const NeverScrollableScrollPhysics(),
                      // Add physics
                      itemCount: _selectedImages?.length ?? 0,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Image.file(File(_selectedImages![index].path));
                      },
                    ),
                  )
                : Container(), // Show an empty container if there are no images
          ],
        ),
      ),
    );
  }
}
