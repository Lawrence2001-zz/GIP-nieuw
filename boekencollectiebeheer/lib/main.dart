import 'package:boekencollectiebeheer/home_widget.dart';
import 'package:boekencollectiebeheer/screens/add_book.dart';
import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

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
        colorScheme: ThemeData.dark().colorScheme.copyWith(primary: Colors.teal.shade300)
      ),
    );
  }
}
