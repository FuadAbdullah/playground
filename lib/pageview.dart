// TODO
// Implement this into Material Quran

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PageView Demo",
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  double? _focusedIndex = 0;
  int _pageCount = 0;
  ScrollController? _scrollController;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _initScrollController();
    _initPageController();
  }

  void _initScrollController() {
    _scrollController = ScrollController(keepScrollOffset: true);
  }

  void _initPageController() {
    _pageController = PageController(
        viewportFraction: 1.0, keepPage: true, initialPage: 0);
    _pageController!.addListener(() {
      _pageControllerListener();
    });
  }

  void _pageControllerListener() {
    setState(() {
      _focusedIndex = _pageController!.page;
    });
  }

  Future<List<dynamic>> _jsonDecoder() async {
    final response = await rootBundle.loadString("json/lorem.json");
    final data = json.decode(response);
    List<dynamic> listCount = data['data'];
    setState(() {
      _pageCount = listCount.length;
    });
    return data['data'];
  }

  void _nextPage() {
    if (_focusedIndex! < _pageCount - 1) {
      setState(() {
        _focusedIndex = _focusedIndex! + 1;
        _pageController!.jumpToPage(_focusedIndex!.toInt());
      });
    }
  }

  void _prevPage() {
    if (_focusedIndex! > 0) {
      setState(() {
        _focusedIndex = _focusedIndex! - 1;
        _pageController!.jumpToPage(_focusedIndex!.toInt());
      });
    }
  }

  Widget _pageContent(snapshot, index) {
    return Container(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Scrollbar(
              controller: _scrollController,
              child: ListView(
                children: [
                  Container(
                      child: Card(
                    color: Colors.white60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("${snapshot.data![index]['id']}"),
                        Divider(),
                        Text("${snapshot.data![index]['word']}")
                      ],
                    ),
                  )),
                ],
              ),
            )));
  }

  Widget _pageBuilder() {
    return FutureBuilder<List<dynamic>>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return PageView.builder(
            controller: _pageController,
            itemBuilder: (context, index) {
              return _pageContent(snapshot, index);
            },
            pageSnapping: true,
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
          );
        } else if (snapshot.hasError) {
          return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("${snapshot.error}"),
                ],
              ));
        }
        return Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            ));
      },
      future: _jsonDecoder(),
    );
  }

  Widget _bottomNavBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () {
            _prevPage();
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
        Divider(),
        IconButton(
          onPressed: () {
            _nextPage();
          },
          icon: Icon(Icons.arrow_forward_ios_rounded),
        ),
      ],
    );
  }

  Widget _mainScreen() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(child: Container(child: _pageBuilder())),
          Container(child: _bottomNavBar())
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController!.removeListener(_pageControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: _mainScreen());
  }
}
