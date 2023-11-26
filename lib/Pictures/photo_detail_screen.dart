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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // moeten we hier nog logica voor tovoegen implementeren SM
                  },
                  child: Text('Toevoegen'),
                ),
                ElevatedButton(
                  onPressed: () {
                    //moeten we hier on DElLETE button implementeren . SM
                  },

                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  child: Text('Verwijderen'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
