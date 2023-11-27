import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'category.dart';

class AddPhotoScreen extends StatefulWidget {
  final Category category;

  const AddPhotoScreen({Key? key, required this.category}) : super(key: key);

  @override
  _AddPhotoScreenState createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  final TextEditingController _titleController = TextEditingController();
  List<PlatformFile> _selectedFiles = [];
  late DropzoneViewController dropzoneController;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedFiles.isNotEmpty && _titleController.text.isNotEmpty) {
      setState(() {
        _selectedFiles = [];
        _titleController.clear();
      });
      Navigator.pop(context);
    }
  }

  Future<void> _selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        _selectedFiles.addAll(result.files);
      });
    }
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
              icon: Icon(Icons.file_upload),
              label: Text('Selecteer bestanden'),
              onPressed: _selectFiles,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
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
                          _selectedFiles.add(PlatformFile(
                            name: file.name,
                            size: file.size,
                            bytes: data,
                            readStream: null,
                          ));
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
              ..._selectedFiles.map((file) => Text(file.name)).toList(),
              SizedBox(height: 20),
            ],
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Titel',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Toevoegen'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Terug'),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
