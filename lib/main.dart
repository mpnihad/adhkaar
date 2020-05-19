
import 'package:adhkaar/database/model/Duaheading.dart';
import 'package:adhkaar/database/modelhelper/DuaHeadingHelper.dart';
import 'package:adhkaar/screens/Details.dart';
import 'package:adhkaar/screens/PrayerScreen.dart';
import 'package:adhkaar/screens/browse_screens.dart';
import 'package:adhkaar/screens/favorite_screen.dart';
import 'package:adhkaar/screens/searchScreen.dart';
import 'package:adhkaar/screens/subdivisionview.dart';
import 'package:adhkaar/utils/BottomNavBarBloc.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:navigation_dot_bar/navigation_dot_bar.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'database/helper/Helper.dart';
import 'icons/prayer_icons_icons.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}
void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');
  // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
  // of the `IOSFlutterLocalNotificationsPlugin` class
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload);
      });

  Provider.debugCheckInvalidValueType = null;


  runApp(MyApp());
}

class MyApp extends StatelessWidget {



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var dbHelper = Helper();

    final _duaHeading = DuaHeadingHelper(dbHelper.db);
    return MultiProvider(
      providers: [
        Provider<DuaHeadingHelper>.value(value: _duaHeading),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: BaseScreen(),
      ),
    );
  }
}

class BaseScreen extends StatefulWidget {
  createState() => BaseScreenState();
}

class BaseScreenState extends State<BaseScreen> {
  BottomNavBarBloc _bottomNavBarBloc;
  bool isKeyboardVisible;
  int count;
  NavBarItem currentItem;
  @override
  void initState() {
    super.initState();
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
    isKeyboardVisible = false;
count=0;
    NavBarItem currentItem = NavBarItem.HOME;
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool isVisible) {

        count++;
        setState(() => isKeyboardVisible = isVisible);
      },
    );
    _bottomNavBarBloc = BottomNavBarBloc();
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    _bottomNavBarBloc.close();
    super.dispose();
  }


  final MethodChannel platform =
  MethodChannel('crossingthestreams.io/resourceResolver');


  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                DuaHeading duaHeading = new DuaHeading.forSearch(
                    37,
                    "എന്നും വൈകുന്നേരം ചൊല്ലേണ്ട ദിക്‌റുകളും ദുആകളും",
                   Color( 0xfff77533));
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailPage(
                          duaHeading: duaHeading,
                        ),
                  ),
                );
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      if(payload=='MORNING') {
        DuaHeading duaHeading = new DuaHeading.forSearch(
            20,
            "എന്നും രാവിലെ ചൊല്ലേണ്ട ദിക്‌റുകളും ദുആകളും",
            Color(0xfff77533));
        Navigator.of(context, rootNavigator: true).pop();
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailPage(
                  duaHeading: duaHeading,
                ),
          ),
        );
      }
      else if(payload=="EVNING")
        {
          DuaHeading duaHeading = new DuaHeading.forSearch(
              37,
              "എന്നും വൈകുന്നേരം ചൊല്ലേണ്ട ദിക്‌റുകളും ദുആകളും",
              Color( 0xfff77533));
          Navigator.of(context, rootNavigator: true).pop();
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DetailPage(
                    duaHeading: duaHeading,
                  ),
            ),
          );
        }
    });
  }



  Future<void> _showDailyAtTime() async {
    var time = Time(08, 27, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'എന്നും രാവിലെ ചൊല്ലേണ്ട ദിക്‌റുകളും ദുആകളും',
        'Daily notification shown at approximately ',
        time,
        platformChannelSpecifics,payload: "MORNING");
  }
 Future<void> _showDailyMorningAtTime() async {
   var time = Time(5, 45, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'എന്നും രാവിലെ ചൊല്ലേണ്ട ദിക്‌റുകളും ദുആകളും',
        'Daily notification shown at approximately',
        time,
        platformChannelSpecifics,payload: "EVNING");
  }
  Future<void> _showDailyEvningAtTime() async {
   var time = Time(16, 45, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        1,
        'എന്നും വൈകുന്നേരം ചൊല്ലേണ്ട ദിക്‌റുകളും ദുആകളും',
        'Daily notification shown at approximately ',
        time,
        platformChannelSpecifics,payload: "EVNING");
  }

  Future<void> _cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _cancelNotification();

    _showDailyMorningAtTime();
    _showDailyEvningAtTime();
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: <Widget>[
          StreamBuilder<NavBarItem>(
              stream: _bottomNavBarBloc.navBarControler.stream,
              initialData: _bottomNavBarBloc.defaultitem,
              builder:
                  (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {

                switch (snapshot.data) {


                  case NavBarItem.HOME:
                    _bottomNavBarBloc.defaultitem=NavBarItem.HOME;
                    return BrowseScreen();
                  case NavBarItem.SEARCH:
                    _bottomNavBarBloc.defaultitem=NavBarItem.SEARCH;
                    return SearchScreen();
                  case NavBarItem.FAVORITE:
                    _bottomNavBarBloc.defaultitem=NavBarItem.FAVORITE;
                    return FavoriteScreen();
                    case NavBarItem.PRAYER:
                    _bottomNavBarBloc.defaultitem=NavBarItem.PRAYER;
                    return PrayerScreen();
                  default:
                    return BrowseScreen();
                }
              }),
          StreamBuilder(
              stream: _bottomNavBarBloc.navBarControler.stream,
              initialData: _bottomNavBarBloc.defaultitem,

              builder: (BuildContext context,
                  AsyncSnapshot<NavBarItem> snapshot) {
//                if(count!=0) {
//                  if (currentItem == NavBarItem.HOME)
//                    _bottomNavBarBloc.pickItem(0);
//                  else if (currentItem == NavBarItem.SEARCH)
//                    _bottomNavBarBloc.pickItem(1);
//                  else if (currentItem == NavBarItem.SETTINGS)
//                    _bottomNavBarBloc.pickItem(2);
//
//                  count=0;
//                }
              return
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: !isKeyboardVisible?75.0:0,
                    color: Colors.transparent,
                    padding: EdgeInsets.only(bottom: 15, right: 10, left: 10),
                    child:
//                  AnimatedBottomNavBar(
//                      currentIndex: _currentPage,
//                      onChange: (index) {
//                        setState(() {
//                          _currentPage = index;
//                        });
//                      }),

                    bottomsheet(),

                  ),

                );


            }
          ),
        ],
      ),
    ));
  }

  Widget bottomsheet() {
    return BottomNavigationDotBar(
//       Usar -> "BottomNavigationDotBar"

        items: <BottomNavigationDotBarItem>[
          BottomNavigationDotBarItem(
              icon: FeatherIcons.grid,
              onTap: () {
                _bottomNavBarBloc.pickItem(0);
                currentItem = NavBarItem.HOME;
                _bottomNavBarBloc.defaultitem=NavBarItem.HOME;
                setState(() {

                });
              }),
          BottomNavigationDotBarItem(
              icon: FeatherIcons.search,
              onTap: () {
                _bottomNavBarBloc.pickItem(1);
                currentItem = NavBarItem.SEARCH;
                _bottomNavBarBloc.defaultitem=NavBarItem.SEARCH;
                setState(() {

                });
              }),
          BottomNavigationDotBarItem(

              icon: FeatherIcons.bookmark,
              onTap: () {
                _bottomNavBarBloc.pickItem(2);
                currentItem = NavBarItem.FAVORITE;
                _bottomNavBarBloc.defaultitem=NavBarItem.FAVORITE;

                setState(() {

                });
              }),
          BottomNavigationDotBarItem(

              icon: PrayerIcons.fashion_1,
              onTap: () {
                _bottomNavBarBloc.pickItem(3);
                currentItem = NavBarItem.PRAYER;
                _bottomNavBarBloc.defaultitem=NavBarItem.PRAYER;

                setState(() {

                });
              }),
        ]

    );
  }
}
