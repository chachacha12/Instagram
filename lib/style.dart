import 'package:flutter/material.dart';

var theme = ThemeData(
  /*   //내 앱의 모든 버튼들에 공통된 디자인 주는법
    textButtonTheme: TextButtonThemeData(   //여기안에 스타일 주면 모든 텍스트버튼들 디자인 바껴야하는데 안바뀔수도..플러터문제..
      //그래서 걍 버튼에 스타일 주고 싶으면 아래처럼 style: TextButton.styleFrom()... 이런 속성 넣어주기
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey,
      )
    ),
   */
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.black,
    ),

    appBarTheme: AppBarTheme(
      color: Colors.white,
      centerTitle: false,
      elevation: 1.0,
      //앱바밑에 비치는 그림자효과조절.. 0.0이면 없어짐
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 25,
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),

    textTheme: TextTheme(
      bodyText2: TextStyle(color: Colors.black),
    ));