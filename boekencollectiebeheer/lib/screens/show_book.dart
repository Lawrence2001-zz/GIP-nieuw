import 'package:boekencollectiebeheer/db/database_helper.dart';
import 'package:boekencollectiebeheer/model/books.dart';
import 'package:boekencollectiebeheer/screens/edit_book.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ShowBook extends StatefulWidget {
  const ShowBook({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<ShowBook> createState() => _ShowBookState();
}

class _ShowBookState extends State<ShowBook> {
  late Book book;

  _delete() async {
    Database db = await BookDatabase.instance.database;

    await db.delete('books', where: 'id = ?', whereArgs: [book.id]);
  }

  @override
  void initState() {
    super.initState();
    getBooks();
  }

  void getBooks() async {
    Future<Book> results = getBook();
    book = await results;
  }

  Future<Book> getBook() {
    return BookDatabase.instance.showBook(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditBook(
                      id: book.id.toInt(),
                      title: book.title,
                      author: book.author!,
                      pages: book.pages!,
                      price: book.price!,
                    )),
          ).then((value) => setState(
                () {
                  getBooks();
                },
              ));
        },
        child: const Icon(Icons.edit),
      ),
      appBar: AppBar(
        title: const Text('Boekencollectiebeheer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _delete();
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: FutureBuilder<Book>(
        future: getBook(),
        builder: (context, AsyncSnapshot<Book> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Title',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  Text(book.title, style: const TextStyle(fontSize: 24.0)),
                  const SizedBox(height: 20.0),
                  const Text('Author',
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10.0),
                  Text(book.author!, style: const TextStyle(fontSize: 24.0)),
                  const SizedBox(height: 20.0),
                  const Text('Page Count',
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10.0),
                  Text(book.pages!, style: const TextStyle(fontSize: 24.0)),
                  const SizedBox(height: 20.0),
                  const Text('Price',
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10.0),
                  Text(book.price!, style: const TextStyle(fontSize: 24.0)),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
