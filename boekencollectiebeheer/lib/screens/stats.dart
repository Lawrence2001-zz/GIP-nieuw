import 'package:boekencollectiebeheer/db/database_helper.dart';
import 'package:boekencollectiebeheer/model/books.dart';
import 'package:flutter/material.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  List<Book> books = [];
  int totalChapters = 0;
  int totalPages = 0;
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    getBooks();
  }

  int getTotalChapters() {
    totalChapters = 0;
    for (int index = 0; index < books.length; index++) {
      totalChapters += books[index].chapters!;
    }
    return totalChapters;
  }

  int getTotalPages() {
    totalPages = 0;
    for (int index = 0; index < books.length; index++) {
      totalPages += books[index].pages!;
    }
    return totalPages;
  }

  double getTotalPrice() {
    totalPrice = 0;
    for (int index = 0; index < books.length; index++) {
      totalPrice += books[index].price!;
    }
    return totalPrice;
  }

  void getBooks() async {
    Future<List<Book>> results = getResults();
    books = await results;
  }

  Future<List<Book>> getResults() {
    return BookDatabase.instance.showAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Book>>(
      future: getResults(),
      builder: (context, AsyncSnapshot<List<Book>> snapshot) {
        if (snapshot.hasData) {
          return Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: ClipRRect(
                    child: Image.asset(
                      'assets/images/Icon.png',
                      scale: 3,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'STATISTICS',
                            style: TextStyle(
                              letterSpacing: 3,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Column(
                            children: [
                              const Text(
                                'Total books',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                books.length.toString(),
                                style: const TextStyle(fontSize: 22.0),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                'Total pages',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                getTotalPages().toString(),
                                style: const TextStyle(fontSize: 22.0),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                'Total chapters',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                getTotalChapters().toString(),
                                style: const TextStyle(fontSize: 22.0),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                'Total price',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '€' + getTotalPrice().toStringAsFixed(2),
                                style: const TextStyle(fontSize: 22.0),
                              ),
                            ],
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.0),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }
}
