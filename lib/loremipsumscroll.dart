import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Lorem Ipsum Scroller",
      home: MyScaffold(),
    );
  }
}

class MyScaffold extends StatefulWidget {
  const MyScaffold({Key? key}) : super(key: key);

  @override
  _MyScaffoldState createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  GlobalKey<ScrollSnapListState> sslKey = GlobalKey();
  int _focusedIndex = 0;
  List<dynamic>? _jsonData;

  @override
  void initState() {
    super.initState();
    _jsonDecoder();
  }

  Future<void> _jsonDecoder() async {
    final response = await rootBundle.loadString("json/lorem.json");
    final data = json.decode(response);
    setState(() {
      _jsonData = data['data'];
    });
  }

  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
    });
  }

  Widget _buildItemDetail() {
    try {
      if (_jsonData!.length > _focusedIndex) {
        return Container(
          height: 30,
          child: Text("Index: $_focusedIndex"),
        );
      }
    } catch (Exception) {
      print("Handled delayed future load for Item Detail Loader.");
    }
    return Container(height: 30, child: Text("No data"));
  }

  Widget _buildListItem(BuildContext context, int index) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Colors.white60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 300,
              child: Text(
                "ID: ${_jsonData![index]['id']}",
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
              child: Divider(
                color: Colors.black12,
                thickness: 1.0,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.50,
              child: ListView(
                children: [
                  Text(
                    "${_jsonData![index]['word']}",
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dirtySnapScrollListLoader() {
    try {
      return ScrollSnapList(
        focusOnItemTap: false,
        onItemFocus: _onItemFocus,
        itemSize: MediaQuery.of(context).size.width,
        itemBuilder: _buildListItem,
        itemCount: _jsonData!.length,
      );
    } catch (Exception) {
      print("Handled delayed future load for Snap Scroll.");
    }
    return Container(height: 0, width: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lorem Ipsum Scroller"),
      ),
      body: Container(
          child: Column(
            children: [
              Expanded(
                child: _dirtySnapScrollListLoader(),
              ),
              _buildItemDetail(),
            ],
          )),
    );
  }
}
