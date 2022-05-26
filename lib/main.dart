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
  var tab = 0; //현재 탭의 상태를 보관할거임.state임
  var data = [];   //서버로부터 받아온 데이터를 state에 저장할거임. 변동이 많은 데이터일거같고 수정도 많을거같아서

  @override
  void initState() {      //MyApp위젯이 첫 로드될때 실행됨
    super.initState();
    getData();
  }

  //근데 http.get()이 함수도 시간이 좀 오래걸리는 함수임(전문용어로 Future). 그래서 async 쓰고 await를 써준거임.
  //근데 initState 안에는 async를 쓸 수 없음..그래서 따로 밖으로 빼서 함수로 만들어준거임
  getData() async {
    var result =  await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));  //get요청 보내주고 그 결과를 반환받아줌.

    //서버가 다운되어서 결과값 안들어오거나 등등 여러가지 예외처리를 잘 생각해야함
    //성공하면 보통 200몇이 반환됨. 실패면 보통 400몇이나 500몇이 반환
    if( result.statusCode ==200){  //요청 성공시 실행할 코드

    }else{  //실패시

    }
    var result2 = jsonDecode(result.body);  //jsonDecode이건 json을 리스트나 맵 등으로 변환해주는 함수임.

    setState(() {
      data = result2;
    });
    print(data);
  }

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
        body: [Home(serverdata: data), Text('샵페이지')][tab], //list에서 특정순서 자료 뽑는 문법임
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
  Home({Key? key, this.serverdata }) : super(key: key);
  final serverdata;

  @override
  Widget build(BuildContext context) {

    //데이터가 서버로부터 도착하고나면 위젯 보여주세요~.  이거 조건문으로 확인안하면 서버로부터 값 가져오기전에 이게 동작해서 에러문구 뜸.
    //state안에 서버데이터값 저장해둬서 다 들어오고나면 알아서 재랜더링되어서 위젯통해 값 보여줄거임
    if(serverdata.isNotEmpty){  //리스트 안비어있는지 물어보는 코드
      return ListView.builder(
        itemCount: 3,
        itemBuilder: (c, i) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Image.network(serverdata[i]['image']),
            Text('좋아요: '+ serverdata[i]['likes'].toString()  , style: TextStyle(fontWeight: FontWeight.bold)),
            Text('글쓴이: '+serverdata[i]['user']),
            Text('글내용: '+serverdata[i]['content']),
            Text('작성일: '+serverdata[i]['date']),

          ]);
        },
      );
    }else{  //여기에 이제 로딩중인 화면 보여주면됨
      return Text('로딩중임');
    }
  }
}
