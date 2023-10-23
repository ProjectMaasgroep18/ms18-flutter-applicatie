import 'package:flutter/material.dart';

import '../menu.dart';

class ListPictures extends StatefulWidget {
  const ListPictures({Key? key}) : super(key: key);

  @override
  State<ListPictures> createState() => ListPicturesState();
}

class ListPicturesState extends State<ListPictures> {
  @override
  Widget build(BuildContext context) {
    return Menu(child: CustomListItemExample());
  }
}

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    super.key,
    required this.thumbnail,
    required this.title,
    required this.user,
    required this.viewCount,
  });

  final Widget thumbnail;
  final String title;
  final String user;
  final int viewCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: thumbnail,
          ),
          Expanded(
            flex: 3,
            child: _VideoDescription(
              title: title,
              user: user,
              viewCount: viewCount,
            ),
          ),
          const Icon(
            Icons.more_vert,
            size: 16.0,
          ),
        ],
      ),
    );
  }
}

class _VideoDescription extends StatelessWidget {
  const _VideoDescription({
    required this.title,
    required this.user,
    required this.viewCount,
  });

  final String title;
  final String user;
  final int viewCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            user,
            style: const TextStyle(fontSize: 10.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 20.0)),
          Container(
            alignment: Alignment.bottomRight,
            child: Text(
              '$viewCount likes',
              style: const TextStyle(fontSize: 10.0),
            ),)
        ],
      ),
    );
  }
}

class CustomListItemExample extends StatelessWidget {
  const CustomListItemExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Foto's 2023"), backgroundColor: Colors.deepOrangeAccent,),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        itemExtent: 106.0,
        children: <CustomListItem>[
          CustomListItem(
            user: 'Geupload door: Rik Smits',
            viewCount: 107,
            thumbnail: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(image: NetworkImage('https://picsum.photos/201'),
                      fit: BoxFit.cover)),
            ),
            title: 'Zeilen op de kralingse plas',
          ),
          CustomListItem(
            user: 'Geupload door: Anoniem',
            viewCount: 61,
            thumbnail: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(image: NetworkImage('https://picsum.photos/202'),
                      fit: BoxFit.cover)),
            ),
            title: 'Groepsfoto 2023',
          ),
          CustomListItem(
            user: 'Geupload door: Soumaia',
            viewCount: 43,
            thumbnail: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(image: NetworkImage('https://picsum.photos/203'),
                      fit: BoxFit.cover)),
            ),
            title: 'Op de boot',
          ),
          CustomListItem(
            user: 'Geupload door: Elder',
            viewCount: 87,
            thumbnail: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(image: NetworkImage('https://picsum.photos/204'),
                      fit: BoxFit.cover)),
            ),
            title: 'Kaart',
          ),
          CustomListItem(
            user: 'Geupload door: Frits',
            viewCount: 15,
            thumbnail: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(image: NetworkImage('https://picsum.photos/205'),
                      fit: BoxFit.cover)),
            ),
            title: 'Uitstapje',
          ),
          CustomListItem(
            user: 'Geupload door: Stefan',
            viewCount: 213,
            thumbnail: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(image: NetworkImage('https://picsum.photos/206'),
                      fit: BoxFit.cover)),
            ),
            title: 'Feestje 9 juli',
          ),
          CustomListItem(
            user: 'Geupload door: Bob',
            viewCount: 9,
            thumbnail: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(image: NetworkImage('https://picsum.photos/207'),
                      fit: BoxFit.cover)),
            ),
            title: 'Tijdens meeting',
          ),
          CustomListItem(
            user: 'Geupload door: Admin',
            viewCount: 0,
            thumbnail: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(image: NetworkImage('https://picsum.photos/208'),
                      fit: BoxFit.cover)),
            ),
            title: 'Groepsfoto 2023',
          ),
          CustomListItem(
            user: 'Geupload door: Admin',
            viewCount: 9,
            thumbnail: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(image: NetworkImage('https://picsum.photos/209'),
                      fit: BoxFit.cover)),
            ),
            title: 'Groepsfoto 2023',
          ),
        ],
      ),
    );
  }
}
