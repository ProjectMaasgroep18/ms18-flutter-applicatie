import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'category.dart';

//Deze pagina voor de knop (Album toevogen )

class AddCategoryScreen extends StatefulWidget {
  final Category? parentCategory;

  AddCategoryScreen({Key? key, this.parentCategory}) : super(key: key);

  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _titleController = TextEditingController();
  DateTime? _selectedDate;
  Color mainColor = Color(0xFF15233d);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: mainColor,
            colorScheme: ColorScheme.light(primary: mainColor, onPrimary: Colors.white),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Album'),
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Album Titel',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate == null
                      ? 'No Date Chosen'
                      : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                  style: TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Kies Datum', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(primary: mainColor),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  //Hier moeten we de nieuwe categorie toevogen in database
                },
                style: ElevatedButton.styleFrom(
                  primary: mainColor,
                  textStyle: TextStyle(color: Colors.white),
                ),
                child:  Text('Opslaan', style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                  textStyle: TextStyle(color: Colors.white),
                ),
                child: Text('Teurg', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
