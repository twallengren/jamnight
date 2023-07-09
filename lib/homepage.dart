import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              const Text('Home Page'),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/performermanager');
                },
                child: const Text('Manage Performers'),
              ),
            ],
          ),
        ));
  }
}
