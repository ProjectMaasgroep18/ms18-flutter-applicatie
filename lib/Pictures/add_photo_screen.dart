import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'category.dart';
import 'photo_viewer_screen.dart';
import 'editable_file.dart';

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

  @override
  void dispose() {
    for (var controller in _titleControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (_selectedFiles.isNotEmpty && _areTitlesValid()) {
      setState(() {
        _selectedFiles = [];
        _titleControllers.clear();
      });
      Navigator.pop(context);
    }
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

  void _viewPhoto(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoViewerScreen(photos: _selectedFiles, initialIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Foto\'s toevoegen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ElevatedButton.icon(
              icon: Icon(Icons.file_upload, color: Colors.white),
              label: Text('Selecteer bestanden', style: TextStyle(color: Colors.white)),
              onPressed: _selectFiles,
              style: ElevatedButton.styleFrom(
                primary: mainColor,
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
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
                        _selectedFiles.isEmpty
                            ? 'Sleep bestanden hier'
                            : 'Geselecteerde bestanden',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                  primary: mainColor,
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
                  primary: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
