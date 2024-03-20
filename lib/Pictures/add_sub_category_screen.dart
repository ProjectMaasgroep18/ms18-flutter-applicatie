import 'package:flutter/material.dart';
import 'category.dart';

class AddSubAlbumScreen extends StatefulWidget {
  final Category parentCategory;

  AddSubAlbumScreen({Key? key, required this.parentCategory}) : super(key: key);

  @override
  _AddSubAlbumScreenState createState() => _AddSubAlbumScreenState();
}

class _AddSubAlbumScreenState extends State<AddSubAlbumScreen> {
  final _formKey = GlobalKey<FormState>();
  String _subAlbumTitle = '';

  void _submit() {
    // Logic for what happens when 'Toevoegen' button is pressed
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Logic to add the sub-album to the parent category
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Sub-Album to "${widget.parentCategory.title}"'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Sub-Album Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _subAlbumTitle = value ?? '';
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: Center(
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text('Toevoegen', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: Center(
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
              ),

            ],
          ),
        ),
      ),
    );
  }
}
