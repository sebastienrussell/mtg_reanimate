import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Album> futureAlbum;
  late bool isUpToDate;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
    isUpToDate = checkIfUpToDate();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          ActionChip(
            backgroundColor: Colors.white,
            avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.update,
                color: Theme.of(context).primaryColor,
              ),
            ),
            label: Text('5.2.0+20220108'), // TODO Change this to a variable
            onPressed: onUpdatePressed,
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<Album>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.title);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator.adaptive();
          },
        ),
      ),
    );
  }

  onUpdatePressed() {
    // TODO Download new version
    // TODO setState and save it locally
    setState(() {});
  }

  bool checkIfUpToDate() {
    // TODO Check locally if the version matches
    return false;
  }
}

// TODO To convert for the chip version in the app bar
// TODO Move to another file
Future<Album> fetchAlbum() async {
  final response = await http.get(
      Uri.parse('https://mtg-reanimate.getsandbox.com/albums/1'),
      headers: {'Content-Type': 'application/json'});

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}
