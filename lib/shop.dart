import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firestore = FirebaseFirestore.instance;  //파이어스토어에 접근하기 위한 객체를 전역으로 생성

final auth = FirebaseAuth.instance; //파베 사용자 로그인 등을 위한 객체

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {

  getData() async {

    try {
      await auth.signInWithEmailAndPassword(
          email: 'kim@test.com',
          password: '123456'
      );
    } catch (e) {
      print(e);
    }

    if(auth.currentUser?.uid == null){
      print('로그인 안된 상태군요');
    } else {
      print('로그인 하셨네');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();

  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('샵페이지임!!'),
    );
  }
}



