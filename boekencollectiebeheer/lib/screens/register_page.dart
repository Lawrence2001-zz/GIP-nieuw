import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  var receivedData;
  bool isRegistered = false;

  Future registerUser() async {
    var apiPath = Uri.parse(
        "https://boekencollectiebeheer.000webhostapp.com/registration.php");
    if (kDebugMode) {
      print('uri ready');
    }

    http.Response response = await http.post(apiPath,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'gebruikersnaam': usernameController.text,
          'wachtwoord':  md5.convert(utf8.encode(passwordController.text)).toString()
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
          .showSnackBar(const SnackBar(content: Text('User Created')));
      isRegistered = true;
    } else if (receivedData['success'] == '3') {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('User Already Exists')));
    } else if (receivedData['success'] == '0') {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error In Registration')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Register'),
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
              await registerUser();
              if (isRegistered) {
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Register',
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
