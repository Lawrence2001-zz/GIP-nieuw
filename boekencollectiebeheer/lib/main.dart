import 'dart:convert';
import 'dart:io';
import 'package:boekencollectiebeheer/db/database_helper.dart';
import 'package:boekencollectiebeheer/home_widget.dart';
import 'package:boekencollectiebeheer/model/books.dart';
import 'package:boekencollectiebeheer/screens/add_book.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  HttpOverrides.global = MyHttpOverrides();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  List<Book> books = [];
  var receivedData;
  bool isDone = false;
  bool? isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    initialization();
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

  Future loggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  }

  void initialization() async {
    await loggedIn();
    books = await getResults();
    if (isLoggedIn!) {
      for (var book in books) {
        await addBook(book.title, book.author!, book.pages!, book.price!,
            book.chapters!, book.volume!);
      }
    }
    FlutterNativeSplash.remove();
  }

  Future<List<Book>> getResults() {
    return BookDatabase.instance.showAll();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boekencollectiebeheer',
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/createBook': (context) => const CreateBook(),
      },
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue,
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ThemeData.dark()
              .colorScheme
              .copyWith(primary: Colors.teal.shade300)),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
