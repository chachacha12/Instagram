import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(theme: style.theme, home: MyApp()));
}

var a = TextStyle(color: Colors.red);

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0; //현재 탭의 상태를 보관할거임

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Instargram'), actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: () {},
            iconSize: 30,
          )
        ]),
        body: [Home(), Text('샵페이지')][tab], //list에서 특정순서 자료 뽑는 문법임
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (i) {
            //i는 바텀네비게이션에서 누르는 버튼 순서번호임. 첫번째 버튼 누르면 i는 0이됨.
            setState(() {
              tab = i;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: '홈'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined), label: '샵'),
          ],
        ));
  }
}

//홈탭에서 보여주는 ui
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (c, i) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.asset('assets/logo.png'),
          Text('좋아요 100', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('글쓴이'),
          Text('글내용'),
        ]);
      },
    );
  }
}
