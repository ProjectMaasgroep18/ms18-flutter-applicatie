import 'package:flutter/material.dart';
import 'photo.dart';
//Deze pagina is de photo details pagina , (als jij op een photo klikt)
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
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.photos.length,
            onPageChanged: (int index) {
              setState(() {
                widget.currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              Photo photo = widget.photos[index];
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.currentIndex > 0)
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios, size: 40, color: mainColor),
                              onPressed: () {
                                _controller.previousPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          Image.network(photo.imageBase64),
                          if (widget.currentIndex < widget.photos.length - 1)
                            IconButton(
                              icon: Icon(Icons.arrow_forward_ios, size: 40, color: mainColor),
                              onPressed: () {
                                _controller.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                        ],
                      ),
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
                            //Opslaan  button logic here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                          ),
                          child: Text('Opslaan', style: TextStyle(color: Colors.white)),
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
                            backgroundColor: Colors.grey,
                          ),
                          child: Text('Verwijderen', style: TextStyle(color: Colors.white)),
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
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
