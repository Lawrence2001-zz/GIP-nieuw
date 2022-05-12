import 'package:boekencollectiebeheer/db/database_helper.dart';
import 'package:boekencollectiebeheer/model/books.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

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
  @override
  Widget build(BuildContext context) {
    _insert() async {
      Database db = await BookDatabase.instance.database;

      Map<String, dynamic> row = {
        BookFields.title: titleController.text,
        BookFields.author: authorController.text,
        BookFields.pages: pagesController.text,
        BookFields.price: priceController.text,
      };

      await db.insert('books', row);
    }

    return Scaffold(
      appBar: AppBar(
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
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _insert();
                Navigator.pop(context); 
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
