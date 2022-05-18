import 'package:boekencollectiebeheer/db/database_helper.dart';
import 'package:boekencollectiebeheer/model/tags.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class TagsPage extends StatefulWidget {
  const TagsPage({Key? key}) : super(key: key);

  @override
  State<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  List<Tags> tags = [];
  final tagsController = TextEditingController();

  _insert() async {
    Database db = await BookDatabase.instance.database;

    Map<String, dynamic> row = {TagsFields.tagName: tagsController.text};

    await db.insert('tags', row);
    tagsController.text = '';
  }

  _delete(int index) async {
    Database db = await BookDatabase.instance.database;

    await db.delete('tags', where: 'id = ?', whereArgs: [tags[index].id]);
  }

  @override
  void initState() {
    super.initState();
    getTags();
  }

  void getTags() async {
    Future<List<Tags>> results = getResults();
    tags = await results;
  }

  Future<List<Tags>> getResults() {
    return BookDatabase.instance.showTags();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tags'),
      ),
      body: Column(
        children: [
          FutureBuilder<List<Tags>>(
              future: getResults(),
              builder: (context, AsyncSnapshot<List<Tags>> snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextField(
                                  controller: tagsController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Fill in custom tag',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5.0),
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _insert();
                                    setState(() {
                                      getTags();
                                    });
                                  },
                                  child: const Text(
                                    '+',
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    fixedSize: MaterialStateProperty.all<Size>(
                                      const Size(0, 60),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: tags.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(tags[index].tagName),
                                trailing: TextButton(
                                  child: const Icon(Icons.remove_circle),
                                  onPressed: () {
                                    _delete(index);
                                    setState(() {
                                      getTags();
                                    });
                                  },
                                ),
                              );
                            },
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
              })
        ],
      ),
    );
  }
}
