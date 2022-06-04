import 'package:boekencollectiebeheer/db/database_helper.dart';
import 'package:boekencollectiebeheer/screens/login_page_2.dart';
import 'package:boekencollectiebeheer/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool? isLoggedIn = false;

  Future<bool> loggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    usernameController.text = prefs.get('username').toString();
    passwordController.text = prefs.get('password').toString();
    return isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  }

  _delete() async {
    Database db = await BookDatabase.instance.database;

    await db.delete('books');
  }

  @override
  void initState() {
    super.initState();
    loggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loggedIn(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return isLoggedIn!
                ? Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      title: const Text('Account information'),
                    ),
                    body: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                                onPressed: () async {},
                                child: const Text(
                                  'Edit',
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
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.symmetric(
                                      horizontal: 50.0,
                                      vertical: 10.0,
                                    ),
                                  ),
                                  fixedSize: MaterialStateProperty.all<Size>(
                                    Size(MediaQuery.of(context).size.width,
                                        65.0),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              ElevatedButton(
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.remove('username');
                                  await prefs.remove('password');
                                  await prefs.remove('uid');
                                  await prefs.setBool('isLoggedIn', false);
                                  setState(() {
                                    _delete();
                                  });
                                },
                                child: const Text(
                                  'Log out',
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
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.symmetric(
                                      horizontal: 50.0,
                                      vertical: 10.0,
                                    ),
                                  ),
                                  fixedSize: MaterialStateProperty.all<Size>(
                                    Size(MediaQuery.of(context).size.width,
                                        65.0),
                                  ),
                                ),
                              )
                            ]),
                      ),
                    ),
                  )
                : Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      title: const Text('Account'),
                    ),
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ignore: sized_box_for_whitespace
                        Container(
                          height: 140.0,
                          child: ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                child: Container(
                                  child: ListTile(
                                    title: const Center(child: Text('Log in')),
                                    onTap: () {
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginPage2()))
                                          .then((value) => setState(() {}));
                                    },
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                child: Container(
                                  child: ListTile(
                                    title:
                                        const Center(child: Text('Register')),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const RegisterPage()));
                                    },
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              )
                            ],
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
        });
  }
}
