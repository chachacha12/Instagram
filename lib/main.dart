import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';


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
  var data = []; //서버로부터 받아온 데이터를 state에 저장할거임. 변동이 많은 데이터일거같고 수정도 많을거같아서
  var bottom_visible = true;
  var userImage;   //유저가 선택한 이미지경로를 저장해줄 state

  //sharedpreference에다가 데이터 저장. - 내 폰 로컬에다가 저장됨
  saveData() async {
    var storage = await SharedPreferences.getInstance();
    storage.setString('name', 'john');   //저장됨
    var result = storage.get('name');
    print(result);
  }


  @override
  void initState() {
    //MyApp위젯이 첫 로드될때 실행됨
    super.initState();
    saveData();
    getData();
  }

  //유저가 +버튼누른 새창에서 게시물 작성한거 data state에 추가해주기위함 - 자식인 Upload위젯으로 보낼거임
  addContent(var map){
    setState(() {
      data.insert(0, map);
    });
    print(data);
  }

  //근데 http.get()이 함수도 시간이 좀 오래걸리는 함수임(전문용어로 Future). 그래서 async 쓰고 await를 써준거임.
  //근데 initState 안에는 async를 쓸 수 없음..그래서 따로 밖으로 빼서 함수로 만들어준거임
  getData() async {
    var result = await http.get(Uri.parse(
        'https://codingapple1.github.io/app/data.json')); //get요청 보내주고 그 결과를 반환받아줌.
    //서버가 다운되어서 결과값 안들어오거나 등등 여러가지 예외처리를 잘 생각해야함
    //성공하면 보통 200몇이 반환됨. 실패면 보통 400몇이나 500몇이 반환
    if (result.statusCode == 200) {
      //요청 성공시 실행할 코드
    } else {
      //실패시
    }
    var result2 =
        jsonDecode(result.body); //jsonDecode이건 json을 리스트나 맵 등으로 변환해주는 함수임.
    setState(() {
      data = result2;
    });
    //print(data);
  }

  //게시물 한개 더 state에 추가해서 보여주기 위한 get요청
  get_more() async {
    var result = await http.get(Uri.parse(
        'https://codingapple1.github.io/app/more1.json')); //get요청 보내주고 그 결과를 반환받아줌.
    //서버가 다운되어서 결과값 안들어오거나 등등 여러가지 예외처리를 잘 생각해야함
    //성공하면 보통 200몇이 반환됨. 실패면 보통 400몇이나 500몇이 반환
    if (result.statusCode == 200) {
      //요청 성공시 실행할 코드
    } else {
      //실패시
    }
    //게시물 한개 더 가져오기로 가져온 이 result2값은 map 타입임
    var result2 =
        jsonDecode(result.body); //jsonDecode이건 json을 리스트나 맵 등으로 변환해주는 함수임.
    setState(() {
      data.add(result2);
    });
    print(data);
  }

  //유저가 스크롤 내릴때 state를 바꿔줄 함수
  downscrolling() {
    setState(() {
      bottom_visible = false;
    });
  }

  //유저가 스크롤 내릴때 빼고 (멈춰있거나 위로 올리거나)
  No_downscrolling() {
    setState(() {
      bottom_visible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Instargram'), actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: () async {
              //갤러리에서 사진이미지 고를 수 있게 이동하는 작업
              var picker = ImagePicker();
              var image = await picker.pickImage(source: ImageSource.gallery, );
              if (image != null) {  //사용자가 아무사진도 안 골랐을때도 고려해야하기에
                setState(() {
                  userImage = File(image.path);
                });
              }
              //새 창띄움
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => Upload( userImage: userImage, addContent: addContent, ) ));
            }, //onpressed
            iconSize: 30,
          )
        ]),
        body: [
          Home(
              serverdata: data,
              get_more: get_more,
              downscrolling: downscrolling,
              No_downscrolling: No_downscrolling),
          Text('샵페이지')
        ][tab],
        //list에서 특정순서 자료 뽑는 문법임
        bottomNavigationBar: Visibility(
          visible: bottom_visible,
          child: BottomNavigationBar(
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
          ),
        ));
  }
} //_myApp

//홈탭에서 보여주는 ui
class Home extends StatefulWidget {
  Home(
      {Key? key,
      this.serverdata,
      this.get_more,
      this.downscrolling,
      this.No_downscrolling})
      : super(key: key);
  final serverdata;
  final get_more; //스크롤 맨밑일때 게시물 1개 더 가져오기 위한 함수
  final downscrolling; //밑으로 스크롤 하면 부모의 downscroll을 변경시켜주기 위한 함수
  final No_downscrolling; //밑으로 스크롤 안할때

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //스크롪 높이 저장해두는 state만들어줌
  var scroll =
      ScrollController(); //ScrollController 이건 위젯같은건 아니고 걍 스크롤정보를 쉽게 저장할 수 있게 해주는 저장함을 만들어주는 함수. 잘 몰라도됨.

  //스크롤 변할때마다 체크해주기 위해 오버라이드함
  @override
  void initState() {
    super.initState();
    //리스너란 왼쪽에 있는 변수가 변할때마다 안의 코드 실행해주는 녀석임.
    scroll.addListener(() {
      //그리고 리스너는 필요없어지면 제거해주는게 성능상 좋음 - 나중에 찾아보기
      //print(scroll.position.pixels);  //스크롤바 현재까지 내린 높이
      //print(scroll.position.maxScrollExtent);  //스크롤바 최대 내릴 수 있는 높이
      //print(scroll.position.userScrollDirection);  //스크롤이 위로 되는중인지 아래로 되는중인지 알려줌

      //맨 밑까지 스크롤 했는지 체크해주는 로직임
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        print('맨밑까지옴');
        //get요청해서 게시물 1개 가져옴
        widget.get_more();
      }
      //스크롤 밑으로 내릴때 하단바 숨겨주기 - 동적ui 3스탭에 따라서 코딩하기
      if (scroll.position.userScrollDirection == ScrollDirection.reverse) {
        print('스크롤 방향 이동중');
        widget.downscrolling();
      } else {
        widget.No_downscrolling();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    //데이터가 서버로부터 도착하고나면 위젯 보여주세요~.  이거 조건문으로 확인안하면 서버로부터 값 가져오기전에 이게 동작해서 에러문구 뜸.
    //state안에 서버데이터값 저장해둬서 다 들어오고나면 알아서 재랜더링되어서 위젯통해 값 보여줄거임
    if (widget.serverdata.isNotEmpty) {
      //리스트 안비어있는지 물어보는 코드
      return ListView.builder(
        itemCount: widget.serverdata.length,
        controller: scroll, //스크롤 높이정보를 감시하기위한 인자
        itemBuilder: (c, i) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //삼항연산자임
                widget.serverdata[i]['image'].runtimeType == String
                    ? Image.network( widget.serverdata[i]['image'])
                    : Image.file( widget.serverdata[i]['image']),

                //Image.network(widget.serverdata[i]['image']),
                Text('좋아요: ${widget.serverdata[i]['likes']}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('글쓴이: ' + widget.serverdata[i]['user']),
                Text('글내용: ' + widget.serverdata[i]['content']),
                Text('작성일: ' + widget.serverdata[i]['date'])
              ]);
        },
      );
    } else {
      //여기에 이제 로딩중인 화면 보여주면됨
      return Text('로딩중임');
    }
  }
}

//유저가 메인화면 상단바의 +버튼 눌러서 게시물 새로 작성할때 화면의 커스텀위젯
class Upload extends StatelessWidget {
  const Upload({Key? key, this.userImage, this.addContent, }) : super(key: key);
  final userImage;
  final addContent;

  @override
  Widget build(BuildContext context) {
    var inputdata = TextEditingController();  //유저가 작성한 글 저장할 변수

    return Scaffold(
      appBar: AppBar(),
      body:
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(userImage),  //파일경로로 이미지 띄우는 법
            Text('이미지업로드화면'),
            TextField(controller: inputdata,),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(       //창닫기 버튼
                  onPressed: () {
                    //페이지 닫기
                    Navigator.pop(context); //context에는 마테리얼앱이 포함된 context를 넣으면됨.
                  },
                  icon: Icon(Icons.close)),
              ElevatedButton(    //업로드 버튼
                  onPressed: (){
                      var map =  {};
                      map['image'] = userImage;
                      map['content'] = inputdata.text.toString();
                      map['likes'] = 5;
                      map['liked'] = false;
                      map['date'] = "Aug 25";
                      map['user'] = "글쓴이";
                      //  _map 위젯 안의 data state에 새로운 게시물 map을 추가해주는 함수
                      addContent(map);
                      Navigator.pop(context); //context에는 마테리얼앱이 포함된 context를 넣으면됨.
                  },
                  child: Text('업로드'))
            ],)
          ],
        ),
      )
    );
  }
}
