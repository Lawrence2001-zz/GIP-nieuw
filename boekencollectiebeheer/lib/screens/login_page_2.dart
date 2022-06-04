import 'dart:convert';
import 'package:boekencollectiebeheer/db/database_helper.dart';
import 'package:boekencollectiebeheer/model/books.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class LoginPage2 extends StatefulWidget {
  const LoginPage2({Key? key}) : super(key: key);

  @override
  State<LoginPage2> createState() => _LoginPage2State();
}

class _LoginPage2State extends State<LoginPage2> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // ignore: prefer_typing_uninitialized_variables
  List<Book> books = [];
  var receivedData;
  bool isLoggedIn = false;

  Future getBooks() async {
    final prefs = await SharedPreferences.getInstance();
    var apiPath = Uri.parse(
        "https://boekencollectiebeheer.000webhostapp.com/get_books.php");
    if (kDebugMode) {
      print('uri ready');
    }
    http.Response response = await http.post(apiPath,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({'gebruikersId': prefs.get('uid')}));

    if (kDebugMode) {
      print('response ready');
    }
    receivedData = json.decode(response.body);
    if (kDebugMode) {
      print("DATA: $receivedData");
    }

    if (receivedData['success'] == '3') {
      return;
    } else if (receivedData['success'] == '1') {
      for (var book in receivedData['books']) {
        await _insert(
            book[0], book[1], book[2], book[3], book[4], book[5], book[6]);
      }
    }
  }

  _insert(String id, String titel, String auteur, String paginas, String prijs,
      String delen, String volume) async {
    Database db = await BookDatabase.instance.database;

    Map<String, dynamic> row = {
      BookFields.id: int.parse(id),
      BookFields.title: titel,
      BookFields.author: auteur,
      BookFields.pages: int.parse(paginas),
      BookFields.price: double.parse(prijs),
      BookFields.chapters: int.parse(delen),
      BookFields.volume: int.parse(volume)
    };

    await db.insert('books', row);
  }

  Future addBook(String titel, String auteur, int paginas, double prijs,
      int delen, int volume) async {
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
          'titel': titel,
          'auteur': auteur,
          'paginas': paginas,
          'prijs': prijs,
          'delen': delen,
          'volume': volume,
          'gebruikersId': prefs.get('uid')
        }));

    if (kDebugMode) {
      print('response ready');
    }
    receivedData = json.decode(response.body);
    if (kDebugMode) {
      print("DATA: ${receivedData['message']}");
    }
  }

  void initialization() async {
    books = await getResults();
    await getBooks();
    for (var book in books) {
      await addBook(book.title, book.author!, book.pages!, book.price!,
          book.chapters!, book.volume!);
    }
  }

  Future<List<Book>> getResults() {
    return BookDatabase.instance.showAll();
  }

  Future logInUser() async {
    var apiPath =
        Uri.parse("https://boekencollectiebeheer.000webhostapp.com/login.php");
    if (kDebugMode) {
      print('uri ready');
    }

    http.Response response = await http.post(apiPath,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'gebruikersnaam': usernameController.text,
          'wachtwoord':
              md5.convert(utf8.encode(passwordController.text)).toString()
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
          .showSnackBar(const SnackBar(content: Text('Login successful')));
      isLoggedIn = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', usernameController.text);
      await prefs.setString('password', passwordController.text);
      await prefs.setInt('uid', int.parse(receivedData['id']));
      await prefs.setBool('isLoggedIn', true);
    } else if (receivedData['success'] == '0') {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Password wrong')));
    } else if (receivedData['success'] == '3') {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('User not found')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Log in'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Username',
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'El Goblino',
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Password',
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Test123',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () async {
              await logInUser();
              if (isLoggedIn) {
                initialization();
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Log in',
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
    );
  }
}
