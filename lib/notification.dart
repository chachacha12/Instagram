import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final notifications = FlutterLocalNotificationsPlugin();


//1. 앱로드시 실행할 기본설정
initNotification() async {

  //안드로이드용 아이콘파일 이름
  var androidSetting = AndroidInitializationSettings('logo');

  //ios에서 앱 로드시 유저에게 권한요청하려면
  var iosSetting = IOSInitializationSettings(          //ios에서 알림띄우기 전 허락받는 코드.
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  var initializationSettings = InitializationSettings(
      android: androidSetting,
      iOS: iosSetting
  );
  await notifications.initialize(
    initializationSettings,
    //알림 누를때 함수실행하고 싶으면
    //onSelectNotification: 함수명추가
  );
}



//2. 이 함수 원하는 곳에서 실행하면 알림 뜸
showNotification() async {

  //알림 띄우기전 안드로이드는 세팅 2가지 필요함.
  var androidDetails = AndroidNotificationDetails(
    '유니크한 알림 채널 ID',                //  'sales_notification_1'  이런거?
    '알림종류 설명',                        // '할인알림' 이나  '회원정보업데이트알림' 이런거
    priority: Priority.high,          //중요도임. 중요도 낮으면 안보일수도... 중요도에 따라 소리여부와 팝업여부 등 결정가능
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),  //앱아이콘 색상 지정가능
  );

  //ios세팅
  var iosDetails = IOSNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  // 알림 id, 제목, 내용 맘대로 채우기
  notifications.show(
      1,                   //개별 알림의 유니크한 ID 숫자임. 알아서 프로그래밍 식으로 기입하면됨..대충 1로 써둔거
      '제목1',
      '내용1',
      NotificationDetails(android: androidDetails, iOS: iosDetails)
  );

  print('show함수 실행끝');
}










