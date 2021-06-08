import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url = 'https://randomuser.me/api/?results=50';
  late List data = [];

  @override
  void initState() {
    super.initState();
    this.makeRequest();
  }

  Future<String> makeRequest() async {
    try {
      var response = await http
          .get(Uri.parse(url), headers: {"Accept": "application/json"});

      setState(() {
        var extractdata = json.decode(response.body);
        data = extractdata["results"];
      });

      /*print(data[0]["name"]["first"]);
      print(data[0]["name"]);
      print(data[0]["name"]["first"]);
      var lastname = data[0]["name"]["last"];
      print('LastName: $lastname');
      */

      return "success";
    } catch (e) {
      return "unable to load url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact List'),
      ),
      body: ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, i) {
          return ListTile(
            title: Text(data[i]["name"]["first"]),
            subtitle: Text(data[i]["phone"]),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(data[i]["picture"]["thumbnail"]),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SecondPage(data[i]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  //const SecondPage({Key? key}) : super(key: key);

  SecondPage(this.data);
  final data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      data["name"]["first"],
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('calling mobile...'),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Color(0xff7c94b6),
                        borderRadius: BorderRadius.circular(30.0),
                        image: DecorationImage(
                            image: NetworkImage(data["picture"]["medium"])),
                        border: Border.all(
                          color: Colors.black54,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 20.0, top: 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildPhoneIcon(
                        'mute', 'assets/microphone.png', Color(0xFFFFE9C6)),
                    _buildPhoneIcon(
                        'keypad', 'assets/nine-circles.png', Color(0xFFFFE9C6)),
                    _buildPhoneIcon(
                        'speaker', 'assets/volume.png', Color(0xFFFFE9C6)),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildPhoneIcon(
                        'add call', 'assets/add-user.png', Color(0xFFFFE9C6)),
                    _buildPhoneIcon(
                        'facetime', 'assets/video-call.png', Color(0xFFFFE9C6)),
                    _buildPhoneIcon('contacts', 'assets/apple-contacts.png',
                        Color(0xFFFFE9C6)),
                  ],
                ),
                SizedBox(height: 40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        color: Colors.red,
                      ),
                      child: TextButton(
                        child: Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildPhoneIcon(String name, String imgpath, Color bgcolor) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: name,
              child: Container(
                width: 75.0,
                height: 75.0,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                      style: BorderStyle.solid,
                    )),
                child: Center(
                  child: Image.asset(
                    imgpath,
                    height: 35.0,
                    width: 35.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Text(name),
          ],
        ),
      ),
    );
  }
}
