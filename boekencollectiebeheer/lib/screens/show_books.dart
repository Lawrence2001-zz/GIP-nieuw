import 'package:boekencollectiebeheer/db/database_helper.dart';
import 'package:boekencollectiebeheer/screens/show_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../model/books.dart';

class ShowBooks extends StatefulWidget {
  const ShowBooks({Key? key}) : super(key: key);

  @override
  State<ShowBooks> createState() => _ShowBooksState();
}

class _ShowBooksState extends State<ShowBooks> {
  List<Book> books = [];
  List<Book> duplicate = [];
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selections = List.generate(_tags.length, (_) => false);
    getBooks();
  }

  void getBooks() async {
    Future<List<Book>> results = getResults();
    books = await results;
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

  final List<String> _tags = [
    "Demon Slayer",
    "Attack on Titan",
    "Spy x Family",
    "Rosario+Vampire"
  ];
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
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
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
              child: ToggleButtons(
                fillColor: Colors.teal,
                selectedColor: Colors.white,
                children: [
                  for (int index = 0; index < _tags.length; index++)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(_tags[index]),
                    ),
                ],
                borderRadius: BorderRadius.circular(30),
                disabledColor: ThemeData.dark().appBarTheme.backgroundColor,
                onPressed: (int index) {
                  setState(() {
                    for (int buttonIndex = 0;
                        buttonIndex < _selections.length;
                        buttonIndex++) {
                      if (buttonIndex == index) {
                        _selections[buttonIndex] = !_selections[buttonIndex];
                        if (_selections[buttonIndex]) {
                          filterSearchResults(_tags[buttonIndex].toLowerCase());
                        } else {
                          getBooks();
                        }
                      } else {
                        _selections[buttonIndex] = false;
                      }
                    }
                  });
                },
                isSelected: _selections,
              ),
            ),
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
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            child: Container(
                              child: ListTile(
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
                              decoration: BoxDecoration(border: Border.all(
                                color: Colors.teal.shade100, width: 1.0
                              ),
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
