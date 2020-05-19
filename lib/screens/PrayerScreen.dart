import 'dart:async';
import 'dart:ui';

import 'package:adhkaar/database/helper/Helper.dart';
import 'package:adhkaar/database/model/Duaheading.dart';
import 'package:adhkaar/database/modelhelper/DuaHeadingHelper.dart';
import 'package:adhkaar/icons/sunset_icons_icons.dart';
import 'package:adhkaar/prayercalculator/src/models/calculation_method.dart';
import 'package:adhkaar/prayercalculator/src/models/high_latitude_adjustment.dart';
import 'package:adhkaar/prayercalculator/src/models/juristic_method.dart';
import 'package:adhkaar/prayercalculator/src/models/location.dart';
import 'package:adhkaar/prayercalculator/src/models/prayer_calculation_settings.dart';
import 'package:adhkaar/prayercalculator/src/models/prayers.dart';
import 'package:adhkaar/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

class PrayerScreen extends StatefulWidget {
  PrayerScreen({Key key}) : super(key: key);

  @override
  _PrayerScreenState createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen>
    with TickerProviderStateMixin {
  var textController = TextEditingController();
  Timer _timer;
  FocusNode _focus;

  double get widthButtonCancel => textController.text?.isEmpty ?? true ? 0 : 50;
  ScrollController _scrollController;
  ScrollController _scrollController1;
  List<PaletteGenerator> pallets;
  List<bool> isExpanded = [];
  bool animation_liststatus;
  bool animation_colorstatus;
  Future<List<DuaHeading>> singleDatalist;

  DateTime currentPrayer;
  Widget _prayerWidget;
  String currentPrayerName;
  int currentPrayerPos = 0;
  List<double> animatedWidth = [36, 36, 36, 36, 36, 36, 36];
  double settingHeight = 0;
  List<double> adjestTime = [0, 0, 0, 0, 0, 0, 0];
  List<bool> animationend = [false, false, false, false, false, false, false];
  var prayer;

  DateTime fajr;
  DateTime sunrise;
  DateTime duhar;
  DateTime asr;
  DateTime magrib;
  DateTime isha;

  DateTime listfajr;
  DateTime listduhar;
  DateTime listasr;
  DateTime listmagrib;
  DateTime listisha;
  int singleDataId;
  DuaHeadingHelper helper;
  DuaHeadingHelper duaHelper;
  bool isVisibleSearch = false;
  String query = "";
  bool lastStatus = true;

  Timer timer;
  double expandedsize;


  var selectedcalculationMethord;
  List<String> calculationMethord = <String>[
    "University of islamic Sciences, Karachi",
    CalculationMethodPreset.universityOfIslamicSciencesKarachi.toString(),
    "Malaysia, Malaysian Islamic Development Department",
    CalculationMethodPreset.departmentOfIslamicAdvancementOfMalaysia.toString(),

    "Egyptian General Survey Authority",
    CalculationMethodPreset.egyptianGeneralAuthorityOfSurvey.toString(),
    "Institution of Geophysics University, Tehran",
    CalculationMethodPreset.instituteOfGeophysicsUniversityOfTehran.toString(),
    "Islamic Society of North America",
    CalculationMethodPreset.islamicSocietyOfNorthAmerica.toString(),
    CalculationMethodPreset.ithnaAshari.toString(),
    CalculationMethodPreset.majlisUgamaIslamSingapura.toString(),
    CalculationMethodPreset.muslimWorldLeague.toString(),
    CalculationMethodPreset.ummAlQuraUniversity.toString(),
    CalculationMethodPreset.unionDesOrganisationsIslamiquesDeFrance.toString(),
    CalculationMethodPreset.unionDesOrganisationsIslamiquesDeFrance.toString(),


  ];
  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  void _onFocusChange() {
    setState(() {
      isVisibleSearch = _focus.hasFocus;
    });
  }

  _scrollListener1() {
//    if (isShrink != lastStatus) {
//      setState(() {
//        lastStatus = isShrink;
//      });
//    }
  }

  bool get isShrink {
    if (!_scrollController.hasClients || _scrollController.positions.length > 1)
      return false;

    return _scrollController.hasClients &&
        _scrollController.offset > (expandedsize - 20);
  }

  @override
  void initState() {
    var dbHelper = Helper();
    helper = DuaHeadingHelper(dbHelper.db);
    duaHelper = DuaHeadingHelper(dbHelper.db);
    _prayerWidget = Container();

    const int year = 2020;
    const int month = 5;
    const int day = 14;
    final DateTime when = DateTime.now();
    final DateTime when30 = DateTime.now().add(Duration(minutes: 30));
    final DateTime when15 = DateTime.now().add(Duration(minutes: 15));

    // Init settings.

    // Init location info.

    // Init settings.
    // Set calculation method to JAKIM (Fajr: 18.0 and Isha: 20.0).
    // Provide all initial default values
    final PrayerCalculationSettings settings = PrayerCalculationSettings(
        (PrayerCalculationSettingsBuilder b) => b
          ..imsakParameter.value = -10.0
          ..imsakParameter.type = PrayerCalculationParameterType.minutesAdjust
          ..calculationMethod.replace(CalculationMethod.fromPreset(
              preset:
                  CalculationMethodPreset.universityOfIslamicSciencesKarachi,
              when: DateTime.now().toUtc()))
          ..juristicMethod.replace(
              JuristicMethod.fromPreset(preset: JuristicMethodPreset.standard))
          ..highLatitudeAdjustment = HighLatitudeAdjustment.none
          ..imsakMinutesAdjustment = 0
          ..fajrMinutesAdjustment = 0
          ..sunriseMinutesAdjustment = 0
          ..dhuhaMinutesAdjustment = 0
          ..dhuhrMinutesAdjustment = 0
          ..asrMinutesAdjustment = 0
          ..maghribMinutesAdjustment = 0
          ..ishaMinutesAdjustment = 0);

    // Init location info.



    final Geocoordinate geo = Geocoordinate((GeocoordinateBuilder b) => b
      ..latitude = 11.86752
      ..longitude = 75.35763
      ..altitude = 13);
    const double timezone = 5.5;

    // Generate prayer times for one day on April 12th, 2018.
    final Prayers prayers = Prayers.on(
        date: when, settings: settings, coordinate: geo, timeZone: timezone);
    print(prayers.imsak);
    print(prayers.fajr);
    fajr = (prayers.fajr);
    print(prayers.sunrise);
    sunrise = prayers.sunrise;
    print(prayers.dhuha);
    print(prayers.dhuhr);
    duhar = (prayers.dhuhr);
    asr = (prayers.asr);
    print(prayers.asr);
    print(prayers.sunset);
    magrib = (prayers.maghrib);
    print(prayers.maghrib);
    isha = (prayers.isha);
    print(prayers.isha);
    print(prayers.midnight);

    timer = new Timer.periodic(new Duration(seconds: 1), (time) {
      print('Something');
    });
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(new Duration(seconds: 1), (time) {
      DateTime when = DateTime.now();
      DateTime when30 = DateTime.now().add(Duration(minutes: 30));
      DateTime when15 = DateTime.now().add(Duration(minutes: 15));
      int durations = when.difference(prayers.fajr).inMinutes;

      if (when30.isBefore(prayers.fajr) ||
          (when.difference(prayers.fajr).inMinutes < 30)) {
        if (currentPrayerPos != 1) {
          currentPrayer = prayers.fajr;
          currentPrayerName = "Fajr";
          currentPrayerPos = 1;
          prayer = currentPrayer.millisecondsSinceEpoch;
          setState(() {
            _prayerWidget = Fajr();
          });
        }
      }
      if (when30.isBefore(prayers.sunrise) ||
          (when.difference(prayers.sunrise).inMinutes < 10)) {
        if (currentPrayerPos != 6) {
          currentPrayer = prayers.sunrise;
          currentPrayerName = "Sunrise";
          currentPrayerPos = 6;
          prayer = currentPrayer.millisecondsSinceEpoch;
          setState(() {
            _prayerWidget = Sunrise();
          });
        }
      } else if (when30.isBefore(prayers.dhuhr) ||
          (when.difference(prayers.dhuhr).inMinutes < 30)) {
        if (currentPrayerPos != 2) {
          currentPrayer = prayers.dhuhr;
          currentPrayerName = "Dhuhr";
          currentPrayerPos = 2;
          prayer = currentPrayer.millisecondsSinceEpoch;
          setState(() {
            _prayerWidget = Duhar();
          });
        }
      } else if (when30.isBefore(prayers.asr) ||
          (when.difference(prayers.asr).inMinutes < 30)) {
        if (currentPrayerPos != 3) {
          currentPrayer = prayers.asr;
          currentPrayerName = "Asr";
          prayer = currentPrayer.millisecondsSinceEpoch;
          currentPrayerPos = 3;
          setState(() {
            _prayerWidget = Asr();
          });
        }
      } else if (when15.isBefore(prayers.maghrib) ||
          (when.difference(prayers.maghrib).inMinutes < 15)) {
        if (currentPrayerPos != 4) {
          currentPrayer = prayers.maghrib;
          currentPrayerName = "Magrib";
          prayer = currentPrayer.millisecondsSinceEpoch;
          currentPrayerPos = 4;
          setState(() {
            _prayerWidget = Magrib();
          });
        }
      } else {
        if (currentPrayerPos != 5) {
          currentPrayer = prayers.isha;
          currentPrayerName = "Ishaa";
          prayer = currentPrayer.millisecondsSinceEpoch;
          currentPrayerPos = 5;
          setState(() {
            _prayerWidget = Isha();
          });
        }
      }

      print("Current Prayer $currentPrayerName   $currentPrayer");
    });

    _focus = FocusNode();
    _focus.addListener(_onFocusChange);

    animation_liststatus = false;
    animation_colorstatus = false;
    pallets = [];

    expandedsize = 180.0;
    _scrollController = ScrollController();
    _scrollController1 = ScrollController();
    _scrollController.addListener(_scrollListener);
    _scrollController1.addListener(_scrollListener1);

    animationController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.dismissed) {
        }
//          animationController.forward();
        else if (status == AnimationStatus.completed) {
          animation_liststatus = true;

          if (animation_colorstatus) {
            _ColorAnimationController1.forward();
          }
          setState(() {});
        }
//          animationController.reverse();
      });

    _ColorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));

    _ColorAnimationController1 =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    _scrollController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController1.removeListener(_scrollListener1);
    super.dispose();
  }

  AnimationController animationController, _ColorAnimationController;
  AnimationController _ColorAnimationController1;

  Animation _colorTween;
  List<Animation> _colorTween1;

  Future<bool> _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          backgroundColor: whitebg,
          body: SafeArea(
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: animationController,
                      curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn))),
              child: new Transform(
                transform: new Matrix4.translationValues(
                    0.0,
                    30 *
                        (1.0 -
                            Tween<double>(begin: 0.0, end: 1.0)
                                .animate(CurvedAnimation(
                                    parent: animationController,
                                    curve: Interval(0.0, 1.0,
                                        curve: Curves.fastOutSlowIn)))
                                .value),
                    0.0),
                child: Container(
//          decoration: BoxDecoration(
//            image: DecorationImage(
//              image: AssetImage("assets/images/background.jpeg"),
//              fit: BoxFit.cover,
////            colorFilter: ColorFilter.mode(Colors.white,BlendMode.multiply),
//            ),
//          ),

                  color: whitebg,
                  child:

//          BackdropFilter(
//            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
//            child:

                      NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification.metrics.axis == Axis.vertical) {
                        _ColorAnimationController.animateTo(
                            scrollNotification.metrics.pixels / 100);
                        return true;
                      }
                      return false;
                    },
                    child: MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: Material(
                          color: Colors.transparent,
                          child: Column(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Positioned(
                                    right: 5,
                                    top: 10,
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.only(right: 10),
                                      child: Stack(
                                        overflow: Overflow.visible,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) => SettingsScreen()));
                                            },
                                            child: CircleAvatar(
                                              backgroundColor: Colors.black,
                                              backgroundImage:
                                                  AssetImage("assets/user.png"),
                                              maxRadius: 16,
                                            ),
                                          ),
                                          Positioned(
                                            left: -5,
                                            bottom: -5,
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.white)),
                                                child: CircleAvatar(
                                                  backgroundColor: darkGreens,
                                                  child: Icon(
                                                    Icons.settings,
                                                    size: 9,
                                                  ),
                                                  maxRadius: 9,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 20,
                                    ),
                                    child: StreamBuilder<Object>(
                                        stream: null,
                                        builder: (context, snapshot) {
                                          return Container(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(bottom: 20),
                                              alignment: Alignment.bottomCenter,
                                              child: Image.asset(
                                                "assets/images/icon.png",
                                                width: 50,
                                                height: 50,
                                              ),
                                            ),
                                          );
                                        }),
                                  ),

//                                FlexibleSpaceBar(
//                                  centerTitle: true,
//                                  titlePadding: const EdgeInsets.only(
//                                      right: 60.0, left: 60.0),
//                                  collapseMode: CollapseMode.parallax,
//                                  title:
//                                ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.bottomCenter,
                                      child: SizedBox(
                                        height: 40.0,
                                        child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Stack(
                                              children: <Widget>[
                                                Center(
                                                  child: Text(
                                                    "Adkhar",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 35.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily:
                                                            'SelametLebaran'),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: currentPrayer == null
                                    ? Container()
                                    : StreamBuilder(
                                        stream: Stream.periodic(
                                            Duration(seconds: 1), (i) => i),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<int> snapshot) {
                                          DateFormat format =
                                              DateFormat("mm:ss");
//                                                                      int now =
//                                                                          DateTime.now().millisecondsSinceEpoch;
////

                                          var now = new DateTime.now();

                                          var date = new DateTime
                                                  .fromMicrosecondsSinceEpoch(
                                              currentPrayer
                                                      .millisecondsSinceEpoch *
                                                  1000);
                                          var diff = date.difference(now);

//

                                          // for prayer after the time
//                                                              Duration
//                                                                  remaining =
//                                                                  Duration(
//                                                                      milliseconds:
//                                                                          now -
//                                                                              duhar.millisecondsSinceEpoch);

                                          // for prayer befor the time
//                                                                      Duration
//                                                                          remaining =
//                                                                          Duration(
//                                                                              milliseconds: (now-prayer));
//
//                                                                      print(DateTime.fromMillisecondsSinceEpoch(remaining.inMilliseconds));

                                          var dateString = "";

                                          var remaingTimeString =
                                              diff.inMinutes;
                                          if ((DateTime.now()
                                                      .microsecondsSinceEpoch -
                                                  currentPrayer
                                                      .microsecondsSinceEpoch) <
                                              0) {
                                            if (diff.inHours == 0) {
                                              dateString =
                                                  '- ${diff.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(diff.inSeconds.remainder(60).toString().padLeft(2, '0'))}';
                                            } else {
                                              dateString =
                                                  '- ${diff.inHours}:${diff.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(diff.inSeconds.remainder(60).toString().padLeft(2, '0'))}';
                                            }
                                          } else {
                                            var diff = now.difference(date);

                                            if (diff.inHours == 0) {
                                              dateString =
                                                  '+ ${diff.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(diff.inSeconds.remainder(60).toString().padLeft(2, '0'))}';
                                            } else {
                                              dateString =
                                                  '+ ${diff.inHours}:${diff.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(diff.inSeconds.remainder(60).toString().padLeft(2, '0'))}';
                                            }
                                          }
                                          print(dateString);
                                          return CustomScrollView(
                                            physics:
                                                AlwaysScrollableScrollPhysics(),
                                            slivers: <Widget>[
//                                SliverAppBar(
//                                  backgroundColor: whitebg,
//                                  floating: true,
//                                  snap: true,
//                                  pinned: true,
//                                  flexibleSpace:
//                                ),

                                              SliverToBoxAdapter(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 25, left: 25),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            50,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                    child: Stack(
                                                      children: <Widget>[
                                                        AnimatedSwitcher(
                                                          child: _prayerWidget,

//                                                  switchOutCurve: Curves.fastOutSlowIn,
//                                                  switchInCurve: Curves.fastOutSlowIn,

//                                                  transitionBuilder:(Widget child,Animation<double> animation){
//                                                    return FadeTransition(
//                                                      child: child, opacity: new CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn),
//                                                    );
//                                                  } ,
                                                          duration:
                                                              const Duration(
                                                                  seconds: 2),
                                                        ),
                                                        Positioned(
                                                            bottom: 10,
                                                            right: 10,
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  Icons
                                                                      .location_on,
                                                                  size: 15,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                Text(
                                                                  "Kannur",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ],
                                                            )),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  top: 16.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text(
                                                                "Next Prayer",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                currentPrayerName,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        25,
                                                                    fontFamily:
                                                                        'Helvetica',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
//                                                    (DateTime.now().microsecondsSinceEpoch -
//                                                                currentPrayer
//                                                                    .microsecondsSinceEpoch) <
//                                                            0
//                                                        ?
                                                              SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      2,
                                                                  child:
                                                                      Container(
                                                                    color: Colors
                                                                        .transparent,
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      dateString,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              40,
                                                                          fontFamily:
                                                                              'ProximaNova',
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ))
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              SliverToBoxAdapter(
                                                  child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 30.0,
                                                    left: 30.0,
                                                    top: 20),
                                                child: Text(
                                                  "Prayer Time",
                                                  style: TextStyle(
                                                      color: lightBlack,
                                                      fontSize: 20,
                                                      fontFamily: 'ProximaNova',
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  textAlign: TextAlign.left,
                                                ),
                                              )),
                                              SliverToBoxAdapter(
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 30.0,
                                                              left: 30,
                                                              bottom: 10,
                                                              top: 10),
                                                      child: Neumorphic(
                                                        boxShape: NeumorphicBoxShape
                                                            .roundRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6)),
                                                        style: NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .flat,
                                                            depth: 8,
                                                            intensity: 0.6,
                                                            lightSource:
                                                                LightSource
                                                                    .topLeft,
                                                            color: Colors.white,
                                                            shadowDarkColor:
                                                                bluePrayerER,
                                                            shadowDarkColorEmboss:
                                                                Colors.white),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 8.0,
                                                                  bottom: 8.0),
                                                          child: Column(
                                                            children: <Widget>[
                                                              SinglePrayer(
                                                                  "Fajr",
                                                                  fajr,
                                                                  SunsetIcons
                                                                      .sunrise,
                                                                  currentPrayerPos ==
                                                                      1,
                                                                  remaingTimeString,
                                                                  1),
                                                              SinglePrayer(
                                                                  "Sunrise",
                                                                  sunrise,
                                                                  SunsetIcons
                                                                      .sunrise_1,
                                                                  currentPrayerPos ==
                                                                      6,
                                                                  remaingTimeString,
                                                                  6),
                                                              SinglePrayer(
                                                                  "Duhar",
                                                                  duhar,
                                                                  SunsetIcons
                                                                      .sun_1,
                                                                  currentPrayerPos ==
                                                                      2,
                                                                  remaingTimeString,
                                                                  2),
                                                              SinglePrayer(
                                                                  "Asr",
                                                                  asr,
                                                                  SunsetIcons
                                                                      .cloudy_2,
                                                                  currentPrayerPos ==
                                                                      3,
                                                                  remaingTimeString,
                                                                  3),
                                                              SinglePrayer(
                                                                  "Magrib",
                                                                  magrib,
                                                                  SunsetIcons
                                                                      .cloudy_2,
                                                                  currentPrayerPos ==
                                                                      4,
                                                                  remaingTimeString,
                                                                  4),
                                                              SinglePrayer(
                                                                  "Ishaa",
                                                                  isha,
                                                                  SunsetIcons
                                                                      .sky_1,
                                                                  currentPrayerPos ==
                                                                      5,
                                                                  remaingTimeString,
                                                                  5),
                                                            ],
                                                          ),
                                                        ),
                                                      ))),

                                              SliverToBoxAdapter(
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 30.0,
                                                              left: 30.0,
                                                              top: 0),
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 8),
                                                        child: Stack(
                                                          children: <Widget>[

                                                            AnimatedContainer(
                                                              duration: Duration(milliseconds: 500),
                                                              height: settingHeight,
                                                              onEnd: () {

                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            20.0),
                                                                child: Neumorphic(
                                                                  boxShape: NeumorphicBoxShape.roundRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6)),
                                                                  style:
                                                                      NeumorphicStyle(
                                                                    shape:
                                                                        NeumorphicShape
                                                                            .flat,
                                                                    depth: 8,
                                                                    intensity:
                                                                        0.6,
                                                                    lightSource:
                                                                        LightSource
                                                                            .topLeft,
                                                                    color: Colors
                                                                        .white,
                                                                    shadowDarkColor:
                                                                        lightBlack,
                                                                    shadowDarkColorEmboss:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              lightBlack,
                                                                          width:
                                                                              1),

                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6.0),
//
                                                                      color: Colors.white
                                                                          .withOpacity(
                                                                              .08),
                                                                    ),
                                                                    padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                                top: 20.0),
                                                                    child: Center(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .spaceBetween,
                                                                        children: <
                                                                            Widget>[
//                            Image(
//                              image: AssetImage(pSection.image),
//                              width: 50.0,
//                              color: Color(pSection.color),
//                              height: 50.0,
//                            ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                top: 10,
                                                                                right: 5,
                                                                                left: 5),
                                                                            child:
                                                                            DropdownButton(
                                                                              items: calculationMethord
                                                                                  .map((value) => DropdownMenuItem(
                                                                                child: Text(
                                                                                  value,
                                                                                  style: TextStyle(color: Color(0xff11b719)),
                                                                                ),
                                                                                value: value,
                                                                              ))
                                                                                  .toList(),
                                                                              onChanged: (selectedAccountType) {
                                                                                print('$selectedAccountType');
                                                                                setState(() {
                                                                                  selectedcalculationMethord = selectedAccountType;
                                                                                });
                                                                              },
                                                                              value: selectedcalculationMethord,
                                                                              isExpanded: true,
                                                                              hint: Text(
                                                                                'Choose Account Type',
                                                                                style: TextStyle(color: Color(0xff11b719)),
                                                                              ),
                                                                            )
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                top: 5,
                                                                                right: 5,
                                                                                left: 5),
                                                                            child:
                                                                                Text(
                                                                              "Hello",
                                                                              maxLines:
                                                                                  1,
                                                                              softWrap:
                                                                                  true,
                                                                              overflow:
                                                                                  TextOverflow.ellipsis,
                                                                              style:
                                                                                  TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 10,
                                                                              ),
                                                                              textAlign:
                                                                                  TextAlign.right,
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                top: 5,
                                                                                right: 5,
                                                                                left: 5),
                                                                            child:
                                                                                Text(
                                                                              "Hello",
                                                                              maxLines:
                                                                                  1,
                                                                              softWrap:
                                                                                  true,
                                                                              overflow:
                                                                                  TextOverflow.ellipsis,
                                                                              style:
                                                                                  TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 10,
                                                                              ),
                                                                              textAlign:
                                                                                  TextAlign.left,
                                                                            ),
                                                                          ),

                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(

                                                              child: InkWell(

                                                                child: Container(
                                                                  decoration:
                                                                  BoxDecoration(


                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        8.0),
//
                                                                    color:
                                                                    Colors.white,
                                                                  ),
                                                                  child:
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        8.0),
                                                                    child: Container(
                                                                        height:
                                                                        35,
                                                                        width: 35,
                                                                        child: Icon(
                                                                            SunsetIcons
                                                                                .settings,size: 20,)),
                                                                  ),
                                                                ),
                                                                onTap: (){
                                                                  print("CLICKED");
                                                                  if(settingHeight==0)
                                                                    settingHeight=100;
                                                                  else
                                                                    settingHeight=0;
                                                                  setState(() {

                                                                  });
                                                                },
                                                              ),
                                                              color: Colors.transparent,
                                                              padding: EdgeInsets.only(right: 5),
                                                              alignment: Alignment.topRight,
                                                            ),

                                                          ],

                                                          overflow: Overflow.visible,
                                                        ),
//      child: ListCard(
//        image:
//        "https://res.cloudinary.com/halva/image/upload/v1588908206/adkhar/20190504_ryuaxg.jpg",
//        title: subSection.name,
//        date: "",
//        inverted: index % 2 == 0 ? false : true,
//        prevColor: Colors.white,
//        palletcolor: pallete,
//      ),
                                                      ))),

                                              SliverToBoxAdapter(
                                                  child: Container(
                                                height: 80,
                                              ))
                                            ],
                                          );
                                        }),
                              ),
                            ],
                          )

//                        NestedScrollView(
//                            physics: AlwaysScrollableScrollPhysics(),
//                            controller: _scrollController,
//                            headerSliverBuilder: (BuildContext context,
//                                bool innerBoxIsScrolled) {
//                              return <Widget>[
//                                ///First sliver is the App Bar
//                                AnimatedBuilder(
//                                    animation: _ColorAnimationController,
//                                    builder: (context, snapshot) {
//                                      return  Container();
////                                        SliverAppBar(
////                                        centerTitle: false,
//////                    title:   Container(
//////
//////                    alignment: Alignment.centerLeft,
//////                    child: Image.asset(
//////                    "assets/images/icon.png",
//////                    width: 50,
//////                    height: 50,
//////                    ),
//////                    ),
////
////                                        ///Properties of app bar
//////                  backgroundColor: isShrink
//////                      ? Color(widget.prevColor)
//////                      : Colors.transparent,
////                                        floating: true,
////                                        pinned: true,
////                                        backgroundColor: whitebg,
////                                        expandedHeight: 180,
////
////                                        actions: <Widget>[
////
////                                        ],
////
////                                        ///Properties of the App Bar when it is expanded
////
////                                      );
//                                    }),
//                              ];
//                            },
//
//                            body:),
                          ),
                    ),
                  ),
//          ),
                ),
              ),
            ),
          )),
    );
  }

  Future<List<DuaHeading>> getSearchData({name}) async {
    List<DuaHeading> dua =
        await Provider.of<DuaHeadingHelper>(context, listen: true)
            .searchProducts(
      query: name,
    );
    return dua;
  }

  Widget SinglePrayer(
    String prayerName,
    DateTime prayerTime,
    IconData sunrise,
    bool remainingTime,
    int remaingTimeString,
    int position,
  ) {
    double prayertextsize = 14;
    DateFormat format = DateFormat("hh:mm");
    return remainingTime
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Neumorphic(
              boxShape: NeumorphicBoxShape.roundRect(
                  borderRadius: BorderRadius.circular(8)),
              padding: EdgeInsets.all(0),
              style: NeumorphicStyle(
                  shape: NeumorphicShape.concave,
                  depth: -8,
                  intensity: .6,
                  lightSource: LightSource.topLeft,
                  color: lightBlack,
                  shadowLightColor: Colors.black,
                  shadowLightColorEmboss: lightBlack,
                  shadowDarkColor: lightBlack,
                  shadowDarkColorEmboss: lightBlack),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: animatedWidth[position],
                onEnd: () {
                  animationend[position] = !animationend[position];
                  setState(() {});
                },
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Icon(
                              sunrise,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Text(
                              prayerName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: prayertextsize,
                                  fontFamily: 'ProximaNova',
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Text(
                              format.format(prayerTime),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: prayertextsize,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Material(
                              color: lightBlack,
                              child: InkWell(
                                  onTap: () {
                                    if (animatedWidth[position] == 62) {
                                      animatedWidth[position] = 36;
                                    } else {
                                      animatedWidth[position] = 62;
                                      animationend[position] = false;
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0),
                                    child: Icon(
                                      SunsetIcons.time,
                                      color: Colors.white,
                                      size: prayertextsize,
                                    ),
                                  )),
                            ))
//                Text(
//                  (remaingTimeString).toString(),
//                  style: TextStyle(
//                      color: Colors.white,
//                      fontSize: prayertextsize,
//                      fontFamily: 'Helvetica',
//                      fontWeight:
//                      FontWeight
//                          .w600),
//                  textAlign:
//                  TextAlign.center,
//                ):Container()
//            :Container(),
//          ),
                      ],
                    ),
                    animatedWidth[position] == 36
                        ? Container()
                        : animationend[position]
                            ? Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 15.0, left: 15.0),
                                    child: Text(
                                      "Adjust Time",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontFamily: 'ProximaNova',
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      thumbShape: RoundSliderThumbShape(
                                          enabledThumbRadius: 4.0),
                                      overlayShape: RoundSliderOverlayShape(
                                          overlayRadius: 14.0),
                                      activeTrackColor: Colors.white,
                                      activeTickMarkColor: Colors.black,
                                      thumbColor: Colors.white,
                                      inactiveTickMarkColor: Colors.grey,
                                      inactiveTrackColor: Colors.black,
                                    ),
                                    child: Slider(
                                      label: '${adjestTime[position].round()}',
                                      value: adjestTime[position],
                                      onChanged: (newRating) {
                                        setState(() =>
                                            adjestTime[position] = newRating);
                                      },
                                      onChangeEnd: (newRating) {
                                        setState(() {
//                            animatedWidth[currentPrayerPos-1] = 36;
                                        });
                                      },
                                      divisions: 240,
                                      min: -120,
                                      max: 120,
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                  ],
                ),
              ),
            ),
          )
        : AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: animatedWidth[position],
            onEnd: () {
              animationend[position] = !animationend[position];
              setState(() {});
            },
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, top: 8.0, bottom: 8.0),
                        child: Icon(
                          sunrise,
                          size: 18,
                          color: lightBlack,
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(
                          prayerName,
                          style: TextStyle(
                              color: lightBlack,
                              fontSize: prayertextsize,
                              fontFamily: 'ProximaNova',
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(
                          format.format(prayerTime),
                          style: TextStyle(
                              color: lightBlack,
                              fontSize: prayertextsize,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              if (animatedWidth[position] == 62) {
                                animatedWidth[position] = 36;
                              } else {
                                animatedWidth[position] = 62;
                                animationend[position] = false;
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 16.0, top: 8.0, bottom: 8.0),
                              child: Icon(
                                SunsetIcons.time,
                                color: lightBlack,
                                size: prayertextsize,
                              ),
                            ),
                          ),
                        ))
//                Text(
//                  (remaingTimeString).toString(),
//                  style: TextStyle(
//                      color: Colors.white,
//                      fontSize: prayertextsize,
//                      fontFamily: 'Helvetica',
//                      fontWeight:
//                      FontWeight
//                          .w600),
//                  textAlign:
//                  TextAlign.center,
//                ):Container()
//            :Container(),
//          ),
                  ],
                ),
                animatedWidth[position] == 36
                    ? Container()
                    : animationend[position]
                        ? Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 25.0, left: 25.0),
                                child: Text(
                                  "Adjust Time",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: 'ProximaNova',
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 4.0),
                                  overlayShape: RoundSliderOverlayShape(
                                      overlayRadius: 14.0),
                                  activeTrackColor: Colors.black,
                                  activeTickMarkColor: Colors.white,
                                  thumbColor: Colors.black,
                                  inactiveTickMarkColor: Colors.black87,
                                  inactiveTrackColor: Colors.grey,
                                ),
                                child: Slider(
                                  label: '${adjestTime[position].round()}',
                                  value: adjestTime[position],
                                  onChanged: (newRating) {
                                    setState(
                                        () => adjestTime[position] = newRating);
                                  },
                                  onChangeEnd: (newRating) {
                                    setState(() {
//                            animatedWidth[currentPrayerPos-1] = 36;
                                    });
                                  },
                                  divisions: 240,
                                  min: -120,
                                  max: 120,
                                ),
                              ),
                            ],
                          )
                        : Container(),
              ],
            ),
          );
  }
}

class Fajr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      child: Image.asset(
        "assets/prayerimage/Fajar.png",
        fit: BoxFit.cover,
      ),
    );
  }
}

class Sunrise extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      child: Image.asset(
        "assets/prayerimage/Sunrise.png",
        fit: BoxFit.cover,
      ),
    );
  }
}

class Duhar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      child: Image.asset(
        "assets/prayerimage/Duhar.png",
        fit: BoxFit.cover,
      ),
    );
  }
}

class Asr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      child: Image.asset(
        "assets/prayerimage/Asr.png",
        fit: BoxFit.cover,
      ),
    );
  }
}

class Magrib extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      child: Image.asset(
        "assets/prayerimage/Magrib.png",
        fit: BoxFit.cover,
      ),
    );
  }
}

class Isha extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      child: Image.asset(
        "assets/prayerimage/Isha.png",
        fit: BoxFit.cover,
      ),
    );
  }
}
