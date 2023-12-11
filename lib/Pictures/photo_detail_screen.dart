import 'package:flutter/material.dart';
import 'photo.dart';

Color mainColor = Color(0xFF15233d);

class PhotoDetailScreen extends StatefulWidget {
  final List<Photo> photos;
  int currentIndex;

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

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Foto informatie'),
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.photos.length,
        onPageChanged: (int index) {
          setState(() {
            widget.currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          Photo photo = widget.photos[index];
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image.network(photo.imageUrl),
                      SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Titel',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            // Toevoegen button logic here
                          },
                          style: ElevatedButton.styleFrom(
                            primary: mainColor,
                          ),
                          child: Text('Toevoegen', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            // Verwijderen button logic here
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                          ),
                          child: Text('Verwijderen', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Left arrow
              if (widget.currentIndex > 0)
                Positioned(
                  left: 10,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios, size: 30, color: mainColor),
                      onPressed: () {
                        _controller.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                ),
              // Right arrow
              if (widget.currentIndex < widget.photos.length - 1)
                Positioned(
                  right: 10,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios, size: 30, color: mainColor),
                      onPressed: () {
                        _controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
