import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'category.dart';

class AddPhotoScreen extends StatefulWidget {
  final Category category;

  const AddPhotoScreen({Key? key, required this.category}) : super(key: key);

  @override
  _AddPhotoScreenState createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  final TextEditingController _titleController = TextEditingController();
  PlatformFile? _selectedFile;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedFile != null && _titleController.text.isNotEmpty) {
      // Implement submit logic moet hier ... SM

      setState(() {
        _selectedFile = null;
        _titleController.clear();
      });
      Navigator.pop(context);
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Foto toevoegen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles();

                if (result != null) {
                  setState(() {
                    _selectedFile = result.files.first;
                  });
                } else {
                }
              },
              child: Text('Selecteer bestanden om te uploaden'),
            ),
            SizedBox(height: 20),
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
            if (_selectedFile != null) ...[
              SizedBox(height: 20),
              Text('Geselecteerd bestand: ${_selectedFile!.name}'),
            ],
          ],
        ),
      ),
    );
  }
}
