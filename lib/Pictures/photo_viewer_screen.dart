import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Pictures/editable_file.dart';

class PhotoViewerScreen extends StatefulWidget {
  final List<EditableFile> photos;
  final int initialIndex;

  PhotoViewerScreen({Key? key, required this.photos, this.initialIndex = 0}) : super(key: key);

  @override
  _PhotoViewerScreenState createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  late int currentIndex;
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _titleController = TextEditingController(text: widget.photos[currentIndex].editableName);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _nextPhoto() {
    if (currentIndex < widget.photos.length - 1) {
      setState(() {
        currentIndex++;
        _titleController.text = widget.photos[currentIndex].editableName;
      });
    }
  }

  void _previousPhoto() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        _titleController.text = widget.photos[currentIndex].editableName;
      });
    }
  }

  void _updateTitle() {
    setState(() {
      widget.photos[currentIndex].editableName = _titleController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Viewer'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.memory(widget.photos[currentIndex].file.bytes!, fit: BoxFit.cover),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _previousPhoto,
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: _nextPhoto,
              ),
            ],
          ),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          ElevatedButton(
            onPressed: _updateTitle,
            child: Text('Update Title'),
          ),
        ],
      ),
    );
  }
}
