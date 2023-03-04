import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_galery_photo/gzn_photo_picker_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String path = "";

  void _pickPhoto() {
    showDialog(
      context: context,
      builder: (context) => PhotoPickerDialog(),
    ).then((value) {
      if (value == null) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(value as String),
      ));
      setState(() {
        path = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Path: $path',
              style: Theme.of(context).textTheme.bodySmall
            ),
             if(path.isNotEmpty) Image.file(File(path)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickPhoto,
        child: const Icon(Icons.camera_alt),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
