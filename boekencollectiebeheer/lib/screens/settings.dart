import 'package:boekencollectiebeheer/screens/tags_page.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Settings',
            style: TextStyle(fontSize: 28.0),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Container(
                  child: ListTile(
                    title: const Center(
                        child: Text(
                      'Tags',
                      style: TextStyle(fontSize: 22.0),
                    )),
                    enableFeedback: true,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const TagsPage()));
                    },
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Container(
                  child: ListTile(
                    title: const Center(
                        child: Text(
                      'Account',
                      style: TextStyle(fontSize: 22.0),
                    )),
                    enableFeedback: true,
                    onTap: () {},
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
