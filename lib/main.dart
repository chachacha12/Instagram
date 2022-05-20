import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(
        iconTheme: IconThemeData(color: Colors.black), //이제
        appBarTheme: AppBarTheme(
            color: Colors.white,
            centerTitle: false,
            elevation: 1.0,  //앱바밑에 비치는 그림자효과조절.. 0.0이면 없어짐
            titleTextStyle: TextStyle(color: Colors.black, fontSize: 25, ),
            actionsIconTheme: IconThemeData(color: Colors.black, size: 40, ),
        ),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.red),
        )

      ),
      home: MyApp()));
}

var a = TextStyle(color: Colors.red);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Instargram'),
          actions: [Icon(Icons.add_box_outlined)],
        ),
        body: Text('dd')
    );
  }
}
