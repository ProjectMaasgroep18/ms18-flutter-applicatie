import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:ms18_applicatie/Pictures/category.dart';
import 'package:ms18_applicatie/Pictures/photo_viewer_screen.dart';
import 'package:ms18_applicatie/Pictures/editable_file.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:exif/exif.dart';
import 'package:ms18_applicatie/globals.dart';

//Deze pagina voor de knop (Photo toevogen )

Color mainColor = Color(0xFF15233d);

class AddPhotoScreen extends StatefulWidget {
  final Category category;

  const AddPhotoScreen({Key? key, required this.category}) : super(key: key);

  @override
  _AddPhotoScreenState createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  final List<TextEditingController> _titleControllers = [];
  List<EditableFile> _selectedFiles = [];
  late DropzoneViewController dropzoneController;
  final ImagePicker picker = ImagePicker();
  XFile? photo;
  File? file;

  @override
  void dispose() {
    for (var controller in _titleControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedFiles.isNotEmpty && _areTitlesValid()) {
      for (var file in _selectedFiles) {
          UploadPhoto(file);
      }
    }
  }

  Future<String>getExifFromFile(var filebytes) async{
    var exif = await readExifFromBytes(filebytes);
    String tag = "";
    exif.forEach((k,v) {
      if(k.contains("DateTimeOriginal")){
        final splitted = "$v".split(" ");
        String date = splitted[0].replaceAll(":", "-");
        String time = splitted[1];
        tag = "$date" + "T" + "$time"+ ".000Z";
      }
    });
    return tag;
  }

  Future<http.Response?> UploadPhoto(var file) async {
    Uint8List listimage = file.file.bytes;
    String preImage = base64Encode(listimage);
    final tag = await getExifFromFile(listimage);
    print(tag);
    return http.post(
        Uri.parse('https://localhost:7059/api/photos'),
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'Title': file.editableName,
          'ImageData': preImage,
          'ContentType': "image/${file.file.extension}",
          'TakenOn': tag
        })
    );
  }

  bool _areTitlesValid() {
    for (var controller in _titleControllers) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  Future<void> _selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        _selectedFiles.addAll(result.files.map((file) => EditableFile(file: file)));
        _titleControllers.addAll(result.files.map((_) => TextEditingController()));
      });
    }
  }

  Future<void> _takePhoto() async {
    var res = await picker.pickImage(source: ImageSource.camera);
    if (res != null) {
      setState(() {
        photo = res;
        file = File(photo!.path);
        _selectedFiles.add(EditableFile(file: PlatformFile(name: res.name, path: res.path, size: 0, bytes: null, readStream: null)));
        _titleControllers.add(TextEditingController());
      });
    }
  }

  void _viewPhoto(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoViewerScreen(photos: _selectedFiles, initialIndex: index),
      ),
    );
  }

  Widget _buildWebContent() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: mainColor, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Stack(
          children: [
            DropzoneView(
              operation: DragOperation.copy,
              cursor: CursorType.grab,
              onCreated: (controller) => this.dropzoneController = controller,
              onLoaded: () => print('Dropzone loaded'),
              onError: (error) => print('Error: $error'),
              onHover: () => print('File hovered'),
              onDrop: (file) async {
                final data = await dropzoneController.getFileData(file);
                setState(() {
                  _selectedFiles.add(EditableFile(file: PlatformFile(
                    name: file.name,
                    size: file.size,
                    bytes: data,
                    readStream: null,
                  )));
                  _titleControllers.add(TextEditingController());
                });
              },
              mime: ['image/jpeg', 'image/png'],
            ),
            Center(
              child: Text(
                _selectedFiles.isEmpty ? 'Sleep bestanden hier' : 'Geselecteerde bestanden',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileContent() {
    return Column(
      children: [
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _takePhoto,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
            textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.camera_alt, color: Colors.white),
              SizedBox(width: 8),
              Text("Maak foto", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        if (photo != null)
          Image.file(
            File(photo!.path),
            width: 250,
            height: 250,
          ),
        SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Foto\'s toevoegen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton.icon(
                icon: Icon(Icons.file_upload, color: Colors.white),
                label: Text('Selecteer bestanden', style: TextStyle(color: Colors.white)),
                onPressed: _selectFiles,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
            if (!isSmallScreen) _buildWebContent(),
            if (isSmallScreen) _buildMobileContent(),
            SizedBox(height: 20),
            if (_selectedFiles.isNotEmpty) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: _selectedFiles.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () => _viewPhoto(index),
                          child: Row(
                            children: [
                              Image.memory(
                                _selectedFiles[index].file.bytes!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: _titleControllers[index],
                                  decoration: InputDecoration(
                                    labelText: 'Titel',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: _submit,
                child: Text('Toevoegen', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Terug', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
