
import 'dart:typed_data';

import 'package:adhkaar/database/model/Duaheading.dart';
import 'package:adhkaar/database/modelhelper/DuaHeadingHelper.dart';
import 'package:adhkaar/database/modelhelper/LocationHelper.dart';
import 'package:adhkaar/prayercalculator/src/models/calculation_method.dart';
import 'package:adhkaar/prayercalculator/src/models/juristic_method.dart';
import 'package:adhkaar/prayercalculator/src/models/location.dart';
import 'package:adhkaar/prayercalculator/src/models/prayer_calculation_settings.dart';
import 'package:adhkaar/prayercalculator/src/models/prayers.dart';
import 'package:adhkaar/screens/Details.dart';
import 'package:adhkaar/screens/PrayerScreen.dart';
import 'package:adhkaar/screens/browse_screens.dart';
import 'package:adhkaar/screens/favorite_screen.dart';
import 'package:adhkaar/screens/searchScreen.dart';
import 'package:adhkaar/screens/subdivisionview.dart';
import 'package:adhkaar/utils/BottomNavBarBloc.dart';
import 'package:adhkaar/utils/prayerConst.dart';
import 'package:cron/cron.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:navigation_dot_bar/navigation_dot_bar.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database/helper/Helper.dart';
import 'database/model/Location.dart';
import 'icons/prayer_icons_icons.dart';
import 'model/MethordModel.dart';


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
    final _locationHelper = LocationHelper(dbHelper.db);
    return MultiProvider(
      providers: [
        Provider<DuaHeadingHelper>.value(value: _duaHeading),
        Provider<LocationHelper>.value(value: _locationHelper),
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
    requestPermission();
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

//   var scheduledNotificationDateTime = DateTime.now(6, 07, 0);
   var scheduledNotificationDateTime = DateTime.now().add(Duration(seconds: 5));
   var vibrationPattern = Int64List(4);
   vibrationPattern[0] = 0;
   vibrationPattern[1] = 1000;
   vibrationPattern[2] = 5000;
   vibrationPattern[3] = 2000;

   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
       'your other channel id',
       'your other channel name',
       'your other channel description',
       styleInformation:  MediaStyleInformation(),
       importance: Importance.Max,priority: Priority.Max,
       sound: RawResourceAndroidNotificationSound('slow_spring_board'),
       largeIcon: DrawableResourceAndroidBitmap('asr'),
       vibrationPattern: vibrationPattern,
       enableLights: true,
       color: const Color.fromARGB(255, 0, 255, 0),
       ledColor: const Color.fromARGB(255, 0, 255, 0),
       ledOnMs: 1000,
       ledOffMs: 500);
   var iOSPlatformChannelSpecifics =
   IOSNotificationDetails(sound: 'slow_spring_board.aiff');
   var platformChannelSpecifics = NotificationDetails(
       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
   await flutterLocalNotificationsPlugin.schedule(
       0,
       'Adkhaar',
       'എന്നും രാവിലെ ചൊല്ലേണ്ട ദിക്‌റുകളും ദുആകളും',
       scheduledNotificationDateTime,
       platformChannelSpecifics,payload: "EVNING");



//    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//        'repeatDailyAtTime channel id',
//        'repeatDailyAtTime channel name',
//        'repeatDailyAtTime description');
//    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//    var platformChannelSpecifics = NotificationDetails(
//        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//    await flutterLocalNotificationsPlugin.showDailyAtTime(
//        0,
//        ,
//        'Daily notification shown at approximately',
//        time,
//        platformChannelSpecifics,payload: "EVNING");
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
        0,
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
    _cronNotifcation();
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

  void _cronNotifcation() {
//   _cancelPrayerNotification();
//    _createSalahNotification();
    var cron = new Cron();
    cron.schedule(new Schedule.parse('0 22 * * *'), () async {
      await _cancelPrayerNotification();
      await _createSalahNotification();

    });

  }

  Future<void> _cancelPrayerNotification() async {
    await flutterLocalNotificationsPlugin.cancel(1);
    await flutterLocalNotificationsPlugin.cancel(2);
    await flutterLocalNotificationsPlugin.cancel(3);
    await flutterLocalNotificationsPlugin.cancel(4);
    await flutterLocalNotificationsPlugin.cancel(5);
    await flutterLocalNotificationsPlugin.cancel(6);
  }

  _createSalahNotification() async {
    prayerConst prayerConsts=prayerConst();
    List<double> adjestTime = [0, 0, 0, 0, 0, 0, 0];
    int selectedCalcMethordPos = 1;
    int selectedAsrJuristicMethordPos = 1;
    int selectedHigherLatitudeMethordPos = 1;
    MethordModel selectedcalculationMethord;
    MethordModel selectedjuristicMethord;
    MethordModel selectedHigherLatitude;
    Location initialLocation;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      adjestTime[1] = sharedPreferences.getDouble("fajrAdjustment") ?? 0;
      adjestTime[6] = sharedPreferences.getDouble("sunriseAdjustment") ?? 0;
      adjestTime[2] = sharedPreferences.getDouble("dhuhrAdjustment") ?? 0;
      adjestTime[3] = sharedPreferences.getDouble("asrAdjustment") ?? 0;
      adjestTime[4] = sharedPreferences.getDouble("magribAdjustment") ?? 0;
      adjestTime[5] = sharedPreferences.getDouble("ishaAdjustment") ?? 0;
      initialLocation=new Location.current(  sharedPreferences.getInt("altitude"),   sharedPreferences.getString("cityName"), sharedPreferences.getString("countryCode"),
          sharedPreferences.getDouble("latitude"),  sharedPreferences.getDouble("longitude"),
          sharedPreferences.getString("timezone"), sharedPreferences.getDouble("utcOffset"));
      selectedCalcMethordPos =
          sharedPreferences.getInt("selectedCalculationMethord") ?? 0;
      selectedAsrJuristicMethordPos =
          sharedPreferences.getInt("selectedJuristicMethord") ?? 0;
      selectedHigherLatitudeMethordPos =
          sharedPreferences.getInt("selectedHigherLatitudeMethord") ?? 0;

      selectedcalculationMethord = prayerConsts.calculationMethord[selectedCalcMethordPos];
      selectedjuristicMethord = prayerConsts.juristicMethord[selectedAsrJuristicMethordPos];
      selectedHigherLatitude = prayerConsts.higherLatitude[selectedHigherLatitudeMethordPos];
    });
    PrayerCalculationSettings settings = PrayerCalculationSettings(
            (PrayerCalculationSettingsBuilder b) => b
          ..imsakParameter.value = -10.0
          ..imsakParameter.type = PrayerCalculationParameterType.minutesAdjust
          ..calculationMethod.replace(CalculationMethod.fromPreset(
              preset: selectedcalculationMethord.calculationMethodPreset,
              when: DateTime.now().toUtc()))
          ..juristicMethod.replace(JuristicMethod.fromPreset(
              preset: selectedjuristicMethord.juristicMethodPreset))
          ..highLatitudeAdjustment =
              selectedHigherLatitude.higherAltitudePresent
          ..imsakMinutesAdjustment = 0
          ..fajrMinutesAdjustment = adjestTime[1].toInt()
          ..sunriseMinutesAdjustment = adjestTime[6].toInt()
          ..dhuhaMinutesAdjustment = 0
          ..dhuhrMinutesAdjustment = adjestTime[2].toInt()
          ..asrMinutesAdjustment = adjestTime[3].toInt()
          ..maghribMinutesAdjustment = adjestTime[4].toInt()
          ..ishaMinutesAdjustment = adjestTime[5].toInt());

    // Init location info.

    Geocoordinate geo = Geocoordinate((GeocoordinateBuilder b) => b
      ..latitude = initialLocation.latitude
      ..longitude = initialLocation.longitude
      ..altitude = initialLocation.altitude+0.0);
    double timezone = initialLocation.utcOffset;

    // Generate prayer times for one day on April 12th, 2018.
    Prayers prayers = Prayers.on(
        date: DateTime.now().add(Duration(days: 1)), settings: settings, coordinate: geo, timeZone: timezone);

//    fajr = (prayers.fajr);
//
//    sunrise = prayers.sunrise;
//
//    duhar = (prayers.dhuhr);
//    asr = (prayers.asr);
//
//    magrib = (prayers.maghrib);
//
//    isha = (prayers.isha);

    await createSalahIndividualNotification(prayers.fajr,"fajar",1);
    await createSalahIndividualNotification(prayers.sunrise,"sunrise",2);
    await createSalahIndividualNotification(prayers.dhuhr,"duhar",3);
    await createSalahIndividualNotification(prayers.asr,"asr",4);
    await createSalahIndividualNotification(prayers.maghrib,"magrib",5);
    await createSalahIndividualNotification(prayers.isha,"isha",6);


  }

  Future<void> createSalahIndividualNotification(DateTime prayerTime, String prayerName,int duration) async {
    DateFormat format =
    DateFormat("hh:mm");
    var scheduledNotificationDateTime = prayerTime;
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id $duration',
        'your other channel name',
        'your other channel description',
        importance: Importance.Max,
        priority: Priority.High,

        visibility: NotificationVisibility.Public,
        styleInformation:  MediaStyleInformation(),
        sound: RawResourceAndroidNotificationSound('slow_spring_board'),
        largeIcon: DrawableResourceAndroidBitmap(prayerName),
        vibrationPattern: vibrationPattern,
        enableLights: true,
        color: const Color.fromARGB(255, 0, 255, 0),
        ledColor: const Color.fromARGB(255, 0, 255, 0),
        ledOnMs: 1000,
        ledOffMs: 500);
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails(sound: 'slow_spring_board.aiff');
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        duration,
        prayerName.toUpperCase()+" ("+format.format(prayerTime)+ ")",
        'Its time for ${prayerName.toUpperCase()} at Kannur',
        scheduledNotificationDateTime,
        platformChannelSpecifics,payload: "EVNING");

  }

  Future<void> requestPermission() async {
    PermissionStatus permission = await LocationPermissions().requestPermissions();
  }


}
