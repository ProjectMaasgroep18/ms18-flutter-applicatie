import 'package:flutter/material.dart';
import 'photo.dart';

class PhotoDetailScreen extends StatelessWidget {
  final Photo photo;

  const PhotoDetailScreen({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Foto informatie'),
      ),
      body: Padding(
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
            ElevatedButton(
              onPressed: () {
                // Toevoegen button logic here
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
              child: Text('Toevoegen'),
            ),
            SizedBox(height: 10), // Space between the buttons
            ElevatedButton(
              onPressed: () {
                // Verwijderen button logic here
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.grey,
              ),
              child: Text('Verwijderen'),
            ),
          ],
        ),
      ),
    );
  }
}
