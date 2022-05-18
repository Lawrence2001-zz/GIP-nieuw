import 'package:boekencollectiebeheer/db/database_helper.dart';
import 'package:boekencollectiebeheer/model/tags.dart';
import 'package:boekencollectiebeheer/screens/show_book.dart';
import 'package:flutter/material.dart';
import '../model/books.dart';

class ShowBooks extends StatefulWidget {
  const ShowBooks({Key? key}) : super(key: key);

  @override
  State<ShowBooks> createState() => _ShowBooksState();
}

class _ShowBooksState extends State<ShowBooks> {
  List<Book> books = [];
  List<Book> duplicate = [];
  List<Tags> tags = [];
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getTags();
    getBooks();
  }

  void getBooks() async {
    Future<List<Book>> results = getResults();
    books = await results;
  }

  void getTags() async {
    Future<List<Tags>> results = getTagResults();
    tags = await results;
    _selections = List.generate(tags.length, (_) => false);
  }

  Future<List<Tags>> getTagResults() {
    return BookDatabase.instance.showTags();
  }

  Future<List<Book>> getResults() {
    return BookDatabase.instance.showAll();
  }

  void filterSearchResults(String query) {
    List<Book> dummySearchList = [];
    dummySearchList.addAll(books);
    if (query.isNotEmpty) {
      List<Book> dummyListData = [];
      for (var item in dummySearchList) {
        if (item.title.toLowerCase().contains(query)) {
          dummyListData.add(item);
        }
      }
      setState(() {
        books.clear();
        books.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        books.clear();
        getBooks();
      });
    }
  }

  List<bool> _selections = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/createBook').then((value) => setState(
                () {
                  getBooks();
                  filterSearchResults(searchController.text);
                },
              ));
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: "Search",
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
              ),
              onChanged: (value) {
                filterSearchResults(value);
              },
            ),
          ),
          const SizedBox(height: 10.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: FutureBuilder<List<Tags>>(
                  future: getTagResults(),
                  builder: (context, AsyncSnapshot<List<Tags>> snapshot) {
                    if (snapshot.hasData) {
                      return ToggleButtons(
                        children: [
                          for (int index = 0; index < tags.length; index++)
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(tags[index].tagName),
                            ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                        disabledColor:
                            ThemeData.dark().appBarTheme.backgroundColor,
                        onPressed: (int index) {
                          setState(() {
                            for (int buttonIndex = 0;
                                buttonIndex < _selections.length;
                                buttonIndex++) {
                              if (buttonIndex == index) {
                                _selections[buttonIndex] =
                                    !_selections[buttonIndex];
                                if (_selections[buttonIndex]) {
                                  filterSearchResults(
                                      tags[buttonIndex].tagName.toLowerCase());
                                } else if (!_selections[buttonIndex]) {
                                  getBooks();
                                }
                              } else {
                                _selections[buttonIndex] = false;
                              }
                            }
                          });
                        },
                        isSelected: _selections,
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                )),
          ),
          const SizedBox(height: 5.0),
          Expanded(
            child: FutureBuilder<List<Book>>(
                future: getResults(),
                builder: (context, AsyncSnapshot<List<Book>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            child: Container(
                              child: ListTile(
                                trailing: Text(
                                    'Volume ${books[index].volume.toString()}'),
                                enableFeedback: true,
                                title: Text(books[index].title),
                                subtitle: Text(books[index].author!),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ShowBook(id: books[index].id),
                                      )).then(
                                    (value) => setState(
                                      () {
                                        getBooks();
                                      },
                                    ),
                                  );
                                },
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          );
                        });
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ],
      ),
    );
  }
}
