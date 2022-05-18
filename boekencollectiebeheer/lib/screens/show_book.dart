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
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final pagesController = TextEditingController();
  final priceController = TextEditingController();
  final chaptersController = TextEditingController();
  final volumeController = TextEditingController();

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
                      chapters: book.chapters!,
                      volume: book.volume!,
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
        centerTitle: true,
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
            titleController.text = book.title;
            authorController.text = book.author!;
            pagesController.text = book.pages.toString();
            priceController.text = book.price.toString();
            chaptersController.text = book.chapters.toString();
            volumeController.text = book.volume.toString();
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Title',
                          style: TextStyle(fontSize: 28.0),
                        ),
                      ),
                      TextField(
                        enabled: false,
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
                        enabled: false,
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
                                  enabled: false,
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
                                  enabled: false,
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
                                  enabled: false,
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
                                  enabled: false,
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
                    ]),
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
