import 'dart:convert';
import 'dart:io';
import 'package:boekencollectiebeheer/db/database_helper.dart';
import 'package:boekencollectiebeheer/model/books.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class CreateBook extends StatefulWidget {
  const CreateBook({Key? key}) : super(key: key);

  @override
  State<CreateBook> createState() => _CreateBookState();
}

class _CreateBookState extends State<CreateBook> {
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final pagesController = TextEditingController();
  final priceController = TextEditingController();
  final chaptersController = TextEditingController();
  final volumeController = TextEditingController();

  // ignore: prefer_typing_uninitialized_variables
  var receivedData;
  bool isDone = false;
  bool? isLoggedIn = false;

  Future loggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  void initState() {
    super.initState();
    loggedIn();
  }

  Future addBook() async {
    final prefs = await SharedPreferences.getInstance();
    var apiPath = Uri.parse(
        "https://boekencollectiebeheer.000webhostapp.com/add_book.php");
    if (kDebugMode) {
      print('uri ready');
    }

    http.Response response = await http.post(apiPath,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
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
    receivedData = json.decode(response.body);
    if (kDebugMode) {
      print("DATA: ${receivedData['message']}");
    }

    if (receivedData['success'] == '1') {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Book added')));
      isDone = true;
    } else if (receivedData['success'] == '3') {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Book already added')));
    } else if (receivedData['success'] == '0') {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error adding book')));
    }
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

      await db.insert('books', row);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add book'),
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
                style: TextStyle(fontSize: 24.0),
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
                style: TextStyle(fontSize: 24.0),
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
                          style: TextStyle(fontSize: 24.0),
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
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
                          style: TextStyle(fontSize: 24.0),
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
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
                try {
                  final result = await InternetAddress.lookup('example.com');
                  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                    if (kDebugMode) {
                      print('connected');
                    }
                    if (isLoggedIn!) {
                      await addBook();
                    } else {
                      isDone = true;
                    }
                  }
                } on SocketException catch (_) {
                  if (kDebugMode) {
                    print('not connected');
                  }
                  isDone = true;
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Book added')));
                }
                if (isDone) {
                  _insert();
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Add book',
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
