import 'package:flutter/material.dart';
import 'style.dart';

void main() {
  runApp(MaterialApp(theme: theme, home: MyApp()));
}

var a = TextStyle(color: Colors.red);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      body: Text('안녕', style: Theme.of(context).textTheme.bodyText2),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: '샵'),
        ],
      )
    );
  }
}
