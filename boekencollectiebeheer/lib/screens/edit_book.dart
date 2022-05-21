import 'dart:convert';

import 'package:boekencollectiebeheer/db/database_helper.dart';
import 'package:boekencollectiebeheer/model/books.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class EditBook extends StatefulWidget {
  const EditBook({
    Key? key,
    required this.id,
    required this.title,
    required this.author,
    required this.pages,
    required this.price,
    required this.chapters,
    required this.volume,
  }) : super(key: key);

  final int id;
  final String title;
  final String author;
  final int pages;
  final double price;
  final int chapters;
  final int volume;

  @override
  State<EditBook> createState() => _CreateBookState();
}

class _CreateBookState extends State<EditBook> {
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final pagesController = TextEditingController();
  final priceController = TextEditingController();
  final chaptersController = TextEditingController();
  final volumeController = TextEditingController();

  var receivedData;
  bool isDone = false;
  bool? isLoggedIn = false;

  Future loggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  }

  Future editBook() async {
    final prefs = await SharedPreferences.getInstance();
    var apiPath = Uri.parse(
        "https://boekencollectiebeheer.000webhostapp.com/update_book.php");
    if (kDebugMode) {
      print('uri ready');
    }

    http.Response response = await http.post(apiPath,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'id': widget.id,
          'titel': titleController.text,
          'auteur': authorController.text,
          'paginas': pagesController.text,
          'prijs': priceController.text,
          'delen': chaptersController.text,
          'volume': volumeController.text,
          'gebruikersId': prefs.get('uid')
        }));

    if (kDebugMode) {
      print('response ready');
    }
    receivedData = response.body;
    if (kDebugMode) {
      print("DATA: $receivedData");
    }
  }

  @override
  void initState() {
    super.initState();
    loggedIn();
    titleController.text = widget.title;
    authorController.text = widget.author;
    pagesController.text = widget.pages.toString();
    priceController.text = widget.price.toString();
    chaptersController.text = widget.chapters.toString();
    volumeController.text = widget.volume.toString();
  }

  @override
  Widget build(BuildContext context) {
    _insert() async {
      Database db = await BookDatabase.instance.database;

      Map<String, dynamic> row = {
        BookFields.title: titleController.text,
        BookFields.author: authorController.text,
        BookFields.pages: int.parse(pagesController.text),
        BookFields.price: double.parse(priceController.text),
        BookFields.chapters: int.parse(chaptersController.text),
        BookFields.volume: int.parse(volumeController.text)
      };

      await db.update('books', row, where: 'id = ?', whereArgs: [widget.id]);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit book'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Title',
                style: TextStyle(fontSize: 28.0),
              ),
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Title',
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Author',
                style: TextStyle(fontSize: 28.0),
              ),
            ),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Author',
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Page count',
                          style: TextStyle(fontSize: 28.0),
                        ),
                      ),
                      TextField(
                        controller: pagesController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Page count',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Price',
                          style: TextStyle(fontSize: 28.0),
                        ),
                      ),
                      TextField(
                        controller: priceController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Price',
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Chapters',
                          style: TextStyle(fontSize: 22.0),
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: chaptersController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Chapters',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Volume',
                          style: TextStyle(fontSize: 22.0),
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: volumeController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Volume',
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                _insert();
                await editBook();
                Navigator.pop(context);
              },
              child: const Text(
                'Edit book',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                ),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(
                    horizontal: 50.0,
                    vertical: 10.0,
                  ),
                ),
                fixedSize: MaterialStateProperty.all<Size>(
                  Size(MediaQuery.of(context).size.width, 65.0),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
