import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final notifications = FlutterLocalNotificationsPlugin();


//1. 앱로드시 실행할 기본설정
initNotification(context) async {

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

      //알림 눌리면 여기 함수에 작성한 내용이 실행됨 - 주로 페이지 띄우기
      onSelectNotification: (payload){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Text('새로운페이지'),
            ),
        );
      }
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
}

//이거 실행하면 알림뜹니다. 근데 원하는 시간, 주기적으로 알림 줄 수 있는 함수임.
showNotification2() async {

  tz.initializeTimeZones();  //이걸 추가해야 시간관련 함수들을 갖다쓸수있음

  //여기는 위의 함수와 같음
  var androidDetails = const AndroidNotificationDetails(
    '유니크한 알림 ID',
    '알림종류 설명',
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),
  );
  var iosDetails = const IOSNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  //기존의 notifications.show()함수와 다르게 시간을 인자로 줘서 알림을 원하는 시간에 알림띄우기 가능
  notifications.zonedSchedule(
      2,
      '제목2',
      '내용2',
      makeDate(8, 30, 0),
      //tz.TZDateTime.now(tz.local).add(Duration(seconds: 3 )),  //tz.TZDateTime.now(tz.local) 여기까지는 폰의 현재 시간을 출력함.
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time  //이 스케줄함수 실행한 시간으로부터 몇시간, 며칠 후(인자선태)에 항상 같은 시간대에 알림 띄워줌
  );
}

//매일 7시에 알림주기 등.. 특정시간대에 주기적으로 알림주는데에 필요한 함수
makeDate(hour, min, sec){
  var now = tz.TZDateTime.now(tz.local);
  var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, min, sec);
  if (when.isBefore(now)) {
    return when.add(Duration(days: 1));
  } else {
    return when;
  }
}








