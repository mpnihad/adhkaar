import 'dart:async';
import 'dart:ui';

import 'package:adhkaar/database/helper/Helper.dart';
import 'package:adhkaar/database/model/Duaheading.dart';
import 'package:adhkaar/database/model/Location.dart';
import 'package:adhkaar/database/modelhelper/DuaHeadingHelper.dart';
import 'package:adhkaar/database/modelhelper/LocationHelper.dart';
import 'package:adhkaar/icons/sunset_icons_icons.dart';
import 'package:adhkaar/model/MethordModel.dart';
import 'package:adhkaar/prayercalculator/src/models/calculation_method.dart';
import 'package:adhkaar/prayercalculator/src/models/high_latitude_adjustment.dart';
import 'package:adhkaar/prayercalculator/src/models/juristic_method.dart';
import 'package:adhkaar/prayercalculator/src/models/location.dart';
import 'package:adhkaar/prayercalculator/src/models/prayer_calculation_settings.dart';
import 'package:adhkaar/prayercalculator/src/models/prayers.dart';
import 'package:adhkaar/utils/colors.dart';
import 'package:adhkaar/utils/prayerConst.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hijri/umm_alqura_calendar.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

bool daySelectedStatus = true;

class PrayerScreen extends StatefulWidget {
  PrayerScreen({Key key}) : super(key: key);

  @override
  _PrayerScreenState createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen>
    with TickerProviderStateMixin {
  Timer _timer;
  Timer _timer1;
  FocusNode _focus;

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

  var calenderDate;

  //for mainitaing sleected prayer
  int prevPrayerPos = 0;
  List<double> animatedWidth = [36, 36, 36, 36, 36, 36, 36];
  double settingHeight = 0;
  List<double> adjestTime = [0, 0, 0, 0, 0, 0, 0];
  int selectedCalcMethordPos = 1;
  int selectedAsrJuristicMethordPos = 1;
  int selectedHigherLatitudeMethordPos = 1;
  List<bool> animationend = [false, false, false, false, false, false, false];
  var prayer;
  AnimationController slidePrayerControler;
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

  Prayers prayers, selectedPrayer;

  SharedPreferences sharedPreferences;
  Location initialLocation;
  Timer timer;
  double expandedsize;
  Geocoordinate geo;

  int calculationMethordPos;

  prayerConst prayerConsts;
  MethordModel selectedcalculationMethord;
  MethordModel selectedjuristicMethord;
  MethordModel selectedHigherLatitude;
  var selectedjuristicMethordPos;

  var selectedHigherLatitudePos;

  CalendarController _calendarController;

  Future<List<DropdownMenuItem>> locationList;

  LocationHelper locationHelper;
  Location selectedValue;

  StreamController<List<Location>> _locationStream;

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

    locationHelper = LocationHelper(dbHelper.db);
//    locationList =
//        getLocationList(locationHelper);

    _prayerWidget = Container();
    _calendarController = CalendarController();
    prayerConsts = prayerConst();
    calenderDate = new ummAlquraCalendar.now();
    const int year = 2020;
    const int month = 5;
    const int day = 14;
    final DateTime when = DateTime.now();
    final DateTime when30 = DateTime.now().add(Duration(minutes: 30));
    final DateTime when15 = DateTime.now().add(Duration(minutes: 15));
    slidePrayerControler = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _focus = FocusNode();
    _focus.addListener(_onFocusChange);
    daySelectedStatus = true;
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
    slidePrayerControler.forward();
    _locationStream = StreamController<List<Location>>.broadcast();
    setAdjustmentTimeInitial(when);

    // Init settings.

    // Init location info.

    // Init settings.
    // Set calculation method to JAKIM (Fajr: 18.0 and Isha: 20.0).
    // Provide all initial default values

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    slidePrayerControler.dispose();
    _calendarController.dispose();
    _scrollController.dispose();
    _locationStream.close();
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
                          child: CustomScrollView(
                            controller: _scrollController,
                            physics: AlwaysScrollableScrollPhysics(),
                            slivers: <Widget>[
                              SliverAppBar(
                                centerTitle: false,
                                floating: true,
                                pinned: true,
                                backgroundColor: whitebg,
                                expandedHeight: 180,

                                actions: <Widget>[
                                  Container(
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.only(right: 10),
                                    child: Stack(
                                      overflow: Overflow.visible,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {

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
                                ],

                                ///Properties of the App Bar when it is expanded
                                flexibleSpace: Stack(
                                  children: <Widget>[
                                    LayoutBuilder(
                                      builder: (BuildContext context,
                                          BoxConstraints constraints) {
                                        double percent =
                                            ((constraints.maxHeight -
                                                    kToolbarHeight) *
                                                100 /
                                                (180 - kToolbarHeight));
                                        double dx = 0;

                                        dx = 100 - percent;
                                        if (constraints.maxHeight == 180) {
                                          dx = 0;
                                        }

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            top: kToolbarHeight / 10,
                                          ),
                                          child: Transform.translate(
                                            child: Container(
                                              alignment: Alignment.bottomCenter,
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(bottom: 20),
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Image.asset(
                                                  "assets/images/icon.png",
                                                  width: 50,
                                                  height: 50,
                                                ),
                                              ),
                                            ),
                                            offset: Offset(
                                                -dx, -kToolbarHeight - 35 + dx),
                                          ),
                                        );
                                      },
                                    ),
                                    FlexibleSpaceBar(
                                      centerTitle: true,
                                      titlePadding: const EdgeInsets.only(
                                          right: 60.0, left: 60.0),
                                      collapseMode: CollapseMode.parallax,
                                      title: Stack(
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.bottomCenter,
                                            child: SizedBox(
                                              height: 90.0,
                                              child: Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Center(
                                                        child: Text(
                                                          "Adkhar",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 25.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  'SelametLebaran'),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SliverFillRemaining(
                                child: currentPrayer == null
                                    ? Container()
                                    : Column(
                                        children: <Widget>[
                                          Expanded(
                                            child: StreamBuilder(
                                                stream: Stream.periodic(
                                                    Duration(seconds: 1),
                                                    (i) => i),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<int>
                                                        snapshot) {
                                                  DateFormat format =
                                                      DateFormat("mm:ss");

                                                  var now = new DateTime.now();

                                                  var date = new DateTime
                                                          .fromMicrosecondsSinceEpoch(
                                                      currentPrayer
                                                              .millisecondsSinceEpoch *
                                                          1000);
                                                  var diff =
                                                      date.difference(now);

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
                                                    var diff =
                                                        now.difference(date);

                                                    if (diff.inHours == 0) {
                                                      dateString =
                                                          '+ ${diff.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(diff.inSeconds.remainder(60).toString().padLeft(2, '0'))}';
                                                    } else {
                                                      dateString =
                                                          '+ ${diff.inHours}:${diff.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(diff.inSeconds.remainder(60).toString().padLeft(2, '0'))}';
                                                    }
                                                  }
//                                          print(dateString);
                                                  var _today =
                                                      new ummAlquraCalendar
                                                          .now();

                                                  return ListView(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 25,
                                                                left: 25),
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              50,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10))),
                                                          child: Stack(
                                                            children: <Widget>[
                                                              AnimatedSwitcher(
                                                                child:
                                                                    _prayerWidget,

//                                                  switchOutCurve: Curves.fastOutSlowIn,
//                                                  switchInCurve: Curves.fastOutSlowIn,

//                                                  transitionBuilder:(Widget child,Animation<double> animation){
//                                                    return FadeTransition(
//                                                      child: child, opacity: new CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn),
//                                                    );
//                                                  } ,
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            2),
                                                              ),
                                                              Positioned(
                                                                  bottom: 0,
                                                                  right: 10,
                                                                  child: Column(
                                                                    children: <
                                                                        Widget>[
                                                                      Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Icon(
                                                                            Icons.location_on,
                                                                            size:
                                                                                15,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          Text(
                                                                            initialLocation.cityName,
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 12,
                                                                                fontFamily: 'ProximaNova',
                                                                                fontWeight: FontWeight.w600),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(bottom: 5.0),
                                                                        child:
                                                                            Text(
                                                                          _today
                                                                              .toFormat("dd MMMM yyyy")
                                                                              .toString(),
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 12,
                                                                              fontFamily: 'ProximaNova',
                                                                              fontWeight: FontWeight.w600),
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                  )),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    top: 16.0),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      "Next Prayer",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w600),
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
                                                                              FontWeight.w600),
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
                                                                        width:
                                                                            MediaQuery.of(context).size.width /
                                                                                2,
                                                                        child:
                                                                            Container(
                                                                          color:
                                                                              Colors.transparent,
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              Text(
                                                                            dateString,
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 40,
                                                                                fontFamily: 'ProximaNova',
                                                                                fontWeight: FontWeight.w600),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 30.0,
                                                                left: 30.0,
                                                                top: 30),
                                                        child: Text(
                                                          "Prayer Time",
                                                          style: TextStyle(
                                                              color: lightBlack,
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  'ProximaNova',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 30.0,
                                                                  left: 30,
                                                                  bottom: 10,
                                                                  top: 10),
                                                          child: Neumorphic(
                                                            boxShape: NeumorphicBoxShape.roundRect(
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
                                                                color: Colors
                                                                    .white,
                                                                shadowDarkColor:
                                                                    bluePrayerER,
                                                                shadowDarkColorEmboss:
                                                                    Colors
                                                                        .white),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 0.0,
                                                                      bottom:
                                                                          8.0),
                                                              child: Column(
                                                                children: <
                                                                    Widget>[
                                                                  _buildTableCalendar(),
                                                                  AnimatedBuilder(
                                                                      animation:
                                                                          slidePrayerControler,
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        return FadeTransition(
                                                                          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                                                                              parent: slidePrayerControler,
                                                                              curve: Curves.fastOutSlowIn)),
                                                                          child:
                                                                              new Transform(
                                                                            transform: new Matrix4.translationValues(
                                                                                -30 * (1.0 - Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: slidePrayerControler, curve: Curves.fastOutSlowIn)).value),
                                                                                0.0,
                                                                                0.0),
//                                                                             new Matrix4.translationValues(
//                                                                            30 *
//                                                                                (1.0 -
//                                                                                    Tween<double>(begin: 0.0, end: 1.0)
//                                                                                        .animate(CurvedAnimation(
//                                                                                        parent:
//                                                                                        dropdownAnimationControler[indexs],
//                                                                                        curve: Interval(
//                                                                                            (1 / data.length) * index, 1.0,
//                                                                                            curve: Curves.fastOutSlowIn)))
//                                                                                        .value),
//                                                                            0.0,
//                                                                            0.0),
                                                                            child:
                                                                                Column(
                                                                              children: <Widget>[
                                                                                Container(
                                                                                  padding: EdgeInsets.only(left: 24, top: 10),
                                                                                  alignment: Alignment.centerLeft,
                                                                                  child: Text(
                                                                                    calenderDate.toFormat("dd MMMM yyyy").toString(),
                                                                                    style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'ProximaNova', fontWeight: FontWeight.w600),
                                                                                    textAlign: TextAlign.left,
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(top: 10.0),
                                                                                  child: SinglePrayer("Fajr", daySelectedStatus ? fajr : selectedPrayer.fajr, SunsetIcons.sunrise, daySelectedStatus ? currentPrayerPos == 0 ? prevPrayerPos == 1 : currentPrayerPos == 1 : false, remaingTimeString, 1),
                                                                                ),
                                                                                SinglePrayer("Sunrise", daySelectedStatus ? sunrise : selectedPrayer.sunrise, SunsetIcons.sunrise_1, daySelectedStatus ? currentPrayerPos == 0 ? prevPrayerPos == 6 : currentPrayerPos == 6 : false, remaingTimeString, 6),
                                                                                SinglePrayer("Duhar", daySelectedStatus ? duhar : selectedPrayer.dhuhr, SunsetIcons.sun_1, daySelectedStatus ? currentPrayerPos == 0 ? prevPrayerPos == 2 : currentPrayerPos == 2 : false, remaingTimeString, 2),
                                                                                SinglePrayer("Asr", daySelectedStatus ? asr : selectedPrayer.asr, SunsetIcons.cloudy_2, daySelectedStatus ? currentPrayerPos == 0 ? prevPrayerPos == 3 : currentPrayerPos == 3 : false, remaingTimeString, 3),
                                                                                SinglePrayer("Magrib", daySelectedStatus ? magrib : selectedPrayer.maghrib, SunsetIcons.cloudy_2, daySelectedStatus ? currentPrayerPos == 0 ? prevPrayerPos == 4 : currentPrayerPos == 4 : false, remaingTimeString, 4),
                                                                                SinglePrayer("Ishaa", daySelectedStatus ? isha : selectedPrayer.isha, SunsetIcons.sky_1, daySelectedStatus ? currentPrayerPos == 0 ? prevPrayerPos == 5 : currentPrayerPos == 5 : false, remaingTimeString, 5),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }),
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 30.0,
                                                                  left: 30.0,
                                                                  top: 0),
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 8),
                                                            child: Stack(
                                                              children: <
                                                                  Widget>[
                                                                AnimatedContainer(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          500),
                                                                  height:
                                                                      settingHeight,
                                                                  onEnd: () {
                                                                    settingHeight !=
                                                                            306
                                                                        ? _scrollController.animateTo(
                                                                            _scrollController
                                                                                .position.minScrollExtent,
                                                                            duration: Duration(
                                                                                seconds:
                                                                                    1),
                                                                            curve: Curves
                                                                                .ease)
                                                                        : _scrollController.animateTo(
                                                                            _scrollController
                                                                                .position.maxScrollExtent,
                                                                            duration:
                                                                                Duration(seconds: 1),
                                                                            curve: Curves.ease);
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            20.0),
                                                                    child:
                                                                        Neumorphic(
                                                                      boxShape: NeumorphicBoxShape.roundRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(6)),
                                                                      style:
                                                                          NeumorphicStyle(
                                                                        shape: NeumorphicShape
                                                                            .flat,
                                                                        depth:
                                                                            8,
                                                                        intensity:
                                                                            0.6,
                                                                        lightSource:
                                                                            LightSource.topLeft,
                                                                        color: Colors
                                                                            .white,
                                                                        shadowDarkColor:
                                                                            lightBlack,
                                                                        shadowDarkColorEmboss:
                                                                            Colors.white,
                                                                      ),
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          border: Border.all(
                                                                              color: lightBlack,
                                                                              width: 1),

                                                                          borderRadius:
                                                                              BorderRadius.circular(6.0),
//
                                                                          color: Colors
                                                                              .white
                                                                              .withOpacity(.08),
                                                                        ),
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                20.0,
                                                                            bottom:
                                                                                20),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: <Widget>[
                                                                              Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.only(left: 8.0),
                                                                                      child: Text(
                                                                                        "Calculation \nMethord",
                                                                                        style: TextStyle(color: lightBlack, fontSize: 12, fontFamily: 'ProximaNova', fontWeight: FontWeight.w600),
                                                                                        textAlign: TextAlign.left,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 4,
                                                                                    child: Padding(
                                                                                        padding: const EdgeInsets.only(right: 5, left: 5),
                                                                                        child: DropdownButton(
                                                                                          items: prayerConsts.calculationMethord
                                                                                              .map((value) => DropdownMenuItem(
                                                                                                    child: Text(
                                                                                                      value.name,
                                                                                                      style: TextStyle(color: Color(0xff11b719), fontSize: 12),
                                                                                                    ),
                                                                                                    value: value,
                                                                                                  ))
                                                                                              .toList(),
                                                                                          onChanged: (selectedAccountType) {
                                                                                            print('$selectedAccountType');
                                                                                            onMethordChanged(selectedAccountType, 1);
                                                                                            setState(() {
                                                                                              selectedcalculationMethord = selectedAccountType;
                                                                                            });
                                                                                          },
                                                                                          isDense: false,
                                                                                          underline: Container(),
                                                                                          value: selectedcalculationMethord,
                                                                                          isExpanded: true,
                                                                                          hint: Text(
                                                                                            selectedcalculationMethord.name,
                                                                                            maxLines: 1,
                                                                                            style: TextStyle(color: Color(0xff11b719), fontSize: 12),
                                                                                            softWrap: true,
                                                                                          ),
                                                                                        )),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.only(left: 8.0),
                                                                                      child: Text(
                                                                                        "Al-Asr \nJuristic Methord",
                                                                                        style: TextStyle(color: lightBlack, fontSize: 12, fontFamily: 'ProximaNova', fontWeight: FontWeight.w600),
                                                                                        textAlign: TextAlign.left,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 4,
                                                                                    child: Padding(
                                                                                        padding: const EdgeInsets.only(right: 5, left: 5),
                                                                                        child: DropdownButton(
                                                                                          items: prayerConsts.juristicMethord
                                                                                              .map((value) => DropdownMenuItem(
                                                                                                    child: Text(
                                                                                                      value.name,
                                                                                                      style: TextStyle(color: Color(0xff11b719), fontSize: 12),
                                                                                                    ),
                                                                                                    value: value,
                                                                                                  ))
                                                                                              .toList(),
                                                                                          onChanged: (selectedAccountType) {
                                                                                            print('$selectedAccountType');
                                                                                            onMethordChanged(selectedAccountType, 2);
                                                                                            setState(() {
                                                                                              selectedjuristicMethord = selectedAccountType;
                                                                                            });
                                                                                          },
                                                                                          isDense: false,
                                                                                          underline: Container(),
                                                                                          value: selectedjuristicMethord,
                                                                                          isExpanded: true,
                                                                                          hint: Text(
                                                                                            'Al-Asr Juristic Methord',
                                                                                            style: TextStyle(color: Color(0xff11b719)),
                                                                                            maxLines: 1,
                                                                                            softWrap: true,
                                                                                          ),
                                                                                        )),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.only(left: 8.0),
                                                                                      child: Text(
                                                                                        "Adjustment for \nHigher Latitude",
                                                                                        style: TextStyle(color: lightBlack, fontSize: 12, fontFamily: 'ProximaNova', fontWeight: FontWeight.w600),
                                                                                        textAlign: TextAlign.left,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 4,
                                                                                    child: Padding(
                                                                                        padding: const EdgeInsets.only(right: 5, left: 5),
                                                                                        child: DropdownButton(
                                                                                          items: prayerConsts.higherLatitude
                                                                                              .map((value) => DropdownMenuItem(
                                                                                                    child: Container(
                                                                                                      child: Text(
                                                                                                        value.name,
                                                                                                        style: TextStyle(color: Color(0xff11b719), fontSize: 12),
                                                                                                      ),
                                                                                                    ),
                                                                                                    value: value,
                                                                                                  ))
                                                                                              .toList(),
                                                                                          onChanged: (selectedAccountType) {
                                                                                            print('$selectedAccountType');
                                                                                            onMethordChanged(selectedAccountType, 3);
                                                                                            setState(() {
                                                                                              selectedHigherLatitude = selectedAccountType;
                                                                                            });
                                                                                          },
                                                                                          isDense: false,
                                                                                          value: selectedHigherLatitude,
                                                                                          isExpanded: true,
                                                                                          underline: Container(),
                                                                                          hint: Text(
                                                                                            'Adjustment for Higher Latitude',
                                                                                            style: TextStyle(color: Color(0xff11b719)),
                                                                                            maxLines: 1,
                                                                                            softWrap: true,
                                                                                          ),
                                                                                        )),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.only(left: 8.0),
                                                                                      child: Text(
                                                                                        "Location",
                                                                                        style: TextStyle(color: lightBlack, fontSize: 12, fontFamily: 'ProximaNova', fontWeight: FontWeight.w600),
                                                                                        textAlign: TextAlign.left,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 4,
                                                                                    child: Row(
                                                                                      children: <Widget>[
                                                                                        Expanded(
                                                                                          child: Material(
                                                                                            child: InkWell(
                                                                                              splashColor: Color(0xff11b719).withOpacity(.2),
                                                                                              child: Padding(
                                                                                                child: Text(
                                                                                                  initialLocation.cityName,
                                                                                                  style: TextStyle(color: Color(0xff11b719), fontSize: 12),
                                                                                                ), padding: EdgeInsets.only(top:4.0,bottom: 4,right: 5, left: 5),

                                                                                              ),
                                                                                              onTap: () {
                                                                                                _openFilteredCountryPickerDialog(context);
                                                                                              },
                                                                                            ),
                                                                                            color: Colors.transparent,
                                                                                          ),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(right:10.0),
                                                                                          child: Icon(FontAwesomeIcons.searchLocation,size: 15,color: lightBlack,),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child:
                                                                      InkWell(
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
//
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                        child: Container(
                                                                            height: 35,
                                                                            width: 35,
                                                                            child: Icon(
                                                                              SunsetIcons.settings,
                                                                              size: 20,
                                                                            )),
                                                                      ),
                                                                    ),
                                                                    onTap: () {
                                                                      print(
                                                                          "CLICKED");
                                                                      if (settingHeight ==
                                                                          0)
                                                                        settingHeight =
                                                                            306;
                                                                      else
                                                                        settingHeight =
                                                                            0;
                                                                      setState(
                                                                          () {});
                                                                    },
                                                                  ),
                                                                  color: Colors
                                                                      .transparent,
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              5),
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                ),
                                                              ],
                                                              overflow: Overflow
                                                                  .visible,
                                                            ),
                                                          )),
                                                      Container(
                                                        height: 80,
                                                      )
                                                    ],
                                                  );
                                                }),
                                          ),
                                        ],
                                      ),
                              ),
                            ],
                          )),
                    ),
                  ),
//          ),
                ),
              ),
            ),
          )),
    );
  }

  Future<List<Location>> getSearchData({name, context}) async {
    List<Location> location =
        await Provider.of<LocationHelper>(context, listen: true).searchLocaiton(
      query: name,
    );

    _locationStream.sink.add(location);
    return location;
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
            padding:
                const EdgeInsets.only(top: 0.0, bottom: 8, right: 8, left: 8),
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
                        daySelectedStatus
                            ? Expanded(
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
                            : Container()
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
                                          setAdjustmentTime();
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
                            left: 16.0, top: 2.0, bottom: 2.0),
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
                        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
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
                        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
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
                    daySelectedStatus
                        ? Expanded(
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
                                      right: 16.0, top: 2.0, bottom: 2.0),
                                  child: Icon(
                                    SunsetIcons.time,
                                    color: lightBlack,
                                    size: prayertextsize,
                                  ),
                                ),
                              ),
                            ))
                        : Container()
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
                                      setAdjustmentTime();
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

  getAdjustmentTime() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      adjestTime[1] = sharedPreferences.getDouble("fajrAdjustment") ?? 0;
      adjestTime[6] = sharedPreferences.getDouble("sunriseAdjustment") ?? 0;
      adjestTime[2] = sharedPreferences.getDouble("dhuhrAdjustment") ?? 0;
      adjestTime[3] = sharedPreferences.getDouble("asrAdjustment") ?? 0;
      adjestTime[4] = sharedPreferences.getDouble("magribAdjustment") ?? 0;
      adjestTime[5] = sharedPreferences.getDouble("ishaAdjustment") ?? 0;
    });
  }

  setAdjustmentTime() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setDouble("fajrAdjustment", adjestTime[1]);
      sharedPreferences.setDouble("sunriseAdjustment", adjestTime[6]);
      sharedPreferences.setDouble("dhuhrAdjustment", adjestTime[2]);
      sharedPreferences.setDouble("asrAdjustment", adjestTime[3]);
      sharedPreferences.setDouble("magribAdjustment", adjestTime[4]);
      sharedPreferences.setDouble("ishaAdjustment", adjestTime[5]);
    });
    CalculationMethodPreset calculationMethodPreset = prayerConsts
        .calculationMethord[selectedCalcMethordPos].calculationMethodPreset;

    JuristicMethodPreset juristicMethodPresets = prayerConsts
        .juristicMethord[selectedAsrJuristicMethordPos].juristicMethodPreset;

    HighLatitudeAdjustment highLatitudeAdjustment = prayerConsts
        .higherLatitude[selectedHigherLatitudeMethordPos].higherAltitudePresent;

    PrayerCalculationSettings settings = PrayerCalculationSettings(
        (PrayerCalculationSettingsBuilder b) => b
          ..imsakParameter.value = -10.0
          ..imsakParameter.type = PrayerCalculationParameterType.minutesAdjust
          ..calculationMethod.replace(CalculationMethod.fromPreset(
              preset: calculationMethodPreset, when: DateTime.now().toUtc()))
          ..juristicMethod
              .replace(JuristicMethod.fromPreset(preset: juristicMethodPresets))
          ..highLatitudeAdjustment = highLatitudeAdjustment
          ..imsakMinutesAdjustment = 0
          ..fajrMinutesAdjustment = adjestTime[1].toInt()
          ..sunriseMinutesAdjustment = adjestTime[6].toInt()
          ..dhuhaMinutesAdjustment = 0
          ..dhuhrMinutesAdjustment = adjestTime[2].toInt()
          ..asrMinutesAdjustment = adjestTime[3].toInt()
          ..maghribMinutesAdjustment = adjestTime[4].toInt()
          ..ishaMinutesAdjustment = adjestTime[5].toInt());

    // Init location info.

    geo = Geocoordinate((GeocoordinateBuilder b) => b
      ..latitude = initialLocation.latitude
      ..longitude = initialLocation.longitude
      ..altitude = initialLocation.altitude + 0.0);
    double timezone = initialLocation.utcOffset;

    DateTime when = DateTime.now();
    prayers = Prayers.on(
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
    prevPrayerPos = currentPrayerPos;
    currentPrayerPos = 0;
  }

  Future<void> onMethordChanged(
      MethordModel selectedcalculationMethord, int methordType) async {
    sharedPreferences = await SharedPreferences.getInstance();

    CalculationMethodPreset calculationMethodPreset = prayerConsts
        .calculationMethord[selectedCalcMethordPos].calculationMethodPreset;

    JuristicMethodPreset juristicMethodPresets = prayerConsts
        .juristicMethord[selectedAsrJuristicMethordPos].juristicMethodPreset;

    HighLatitudeAdjustment highLatitudeAdjustment = prayerConsts
        .higherLatitude[selectedHigherLatitudeMethordPos].higherAltitudePresent;
    if (methordType == 1) {
      sharedPreferences.setInt(
          "selectedCalculationMethord", selectedcalculationMethord.id - 1);
      selectedCalcMethordPos = selectedcalculationMethord.id - 1;
      calculationMethodPreset =
          selectedcalculationMethord.calculationMethodPreset;
    } else if (methordType == 2) {
      sharedPreferences.setInt(
          "selectedJuristicMethord", selectedcalculationMethord.id - 1);
      selectedAsrJuristicMethordPos = selectedcalculationMethord.id - 1;
      juristicMethodPresets = selectedcalculationMethord.juristicMethodPreset;
    } else if (methordType == 3) {
      sharedPreferences.setInt(
          "selectedHigherLatitudeMethord", selectedcalculationMethord.id - 1);
      selectedHigherLatitudeMethordPos = selectedcalculationMethord.id - 1;
      highLatitudeAdjustment = selectedcalculationMethord.higherAltitudePresent;
    }

    PrayerCalculationSettings settings = PrayerCalculationSettings(
        (PrayerCalculationSettingsBuilder b) => b
          ..imsakParameter.value = -10.0
          ..imsakParameter.type = PrayerCalculationParameterType.minutesAdjust
          ..calculationMethod.replace(CalculationMethod.fromPreset(
              preset: calculationMethodPreset, when: DateTime.now().toUtc()))
          ..juristicMethod
              .replace(JuristicMethod.fromPreset(preset: juristicMethodPresets))
          ..highLatitudeAdjustment = highLatitudeAdjustment
          ..imsakMinutesAdjustment = 0
          ..fajrMinutesAdjustment = adjestTime[1].toInt()
          ..sunriseMinutesAdjustment = adjestTime[6].toInt()
          ..dhuhaMinutesAdjustment = 0
          ..dhuhrMinutesAdjustment = adjestTime[2].toInt()
          ..asrMinutesAdjustment = adjestTime[3].toInt()
          ..maghribMinutesAdjustment = adjestTime[4].toInt()
          ..ishaMinutesAdjustment = adjestTime[5].toInt());

    // Init location info.

    geo = Geocoordinate((GeocoordinateBuilder b) => b
      ..latitude = initialLocation.latitude
      ..longitude = initialLocation.longitude
      ..altitude = initialLocation.altitude + 0.0);
    double timezone = initialLocation.utcOffset;

    DateTime when = DateTime.now();
    prayers = Prayers.on(
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
    prevPrayerPos = currentPrayerPos;
    currentPrayerPos = 0;
    setState(() {});
  }

  getCalculationMethord() async {
    sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {});
  }

  Future<void> setAdjustmentTimeInitial(DateTime when) async {
    sharedPreferences = await SharedPreferences.getInstance();
    Location location;
    Position position;
    List<Placemark> placemark;

    double utc;
    if (sharedPreferences.getDouble("latitude") == null) {
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      placemark = await Geolocator().placemarkFromCoordinates(21.3891, 39.8579);

      print(
          "${placemark[0].country} ${placemark[0].isoCountryCode}  ${placemark[0].administrativeArea} ${placemark[0].locality} ${placemark[0].postalCode} ${placemark[0].subLocality}");

      int min = position.timestamp.toLocal().minute -
          (position.timestamp.toUtc()).minute.abs();
      int hour = position.timestamp.toLocal().hour -
          (position.timestamp.toUtc()).hour.abs();
      utc = hour + (min / 60);
    }
    setState(() {
      adjestTime[1] = sharedPreferences.getDouble("fajrAdjustment") ?? 0;
      adjestTime[6] = sharedPreferences.getDouble("sunriseAdjustment") ?? 0;
      adjestTime[2] = sharedPreferences.getDouble("dhuhrAdjustment") ?? 0;
      adjestTime[3] = sharedPreferences.getDouble("asrAdjustment") ?? 0;
      adjestTime[4] = sharedPreferences.getDouble("magribAdjustment") ?? 0;
      adjestTime[5] = sharedPreferences.getDouble("ishaAdjustment") ?? 0;

      if (sharedPreferences.getDouble("latitude") == null) {
        Location locations = new Location.current(
            position.altitude.round(),
            "${placemark[0].subLocality}, ${placemark[0].locality}",
            "${placemark[0].isoCountryCode}",
            position.latitude,
            position.longitude,
            position.timestamp.timeZoneName,
            utc);

        initialLocation = locations;
        location = locations;
      } else {
        initialLocation = new Location.current(
            sharedPreferences.getInt("altitude"),
            sharedPreferences.getString("cityName"),
            sharedPreferences.getString("countryCode"),
            sharedPreferences.getDouble("latitude"),
            sharedPreferences.getDouble("longitude"),
            sharedPreferences.getString("timezone"),
            sharedPreferences.getDouble("utcOffset"));
      }

      selectedCalcMethordPos =
          sharedPreferences.getInt("selectedCalculationMethord") ?? 0;
      selectedAsrJuristicMethordPos =
          sharedPreferences.getInt("selectedJuristicMethord") ?? 0;
      selectedHigherLatitudePos =
          sharedPreferences.getInt("selectedHigherLatitudeMethord") ?? 0;

      selectedcalculationMethord =
          prayerConsts.calculationMethord[selectedCalcMethordPos];
      selectedjuristicMethord =
          prayerConsts.juristicMethord[selectedAsrJuristicMethordPos];
      selectedHigherLatitude =
          prayerConsts.higherLatitude[selectedHigherLatitudeMethordPos];
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

    geo = Geocoordinate((GeocoordinateBuilder b) => b
      ..latitude = initialLocation.latitude
      ..longitude = initialLocation.longitude
      ..altitude = initialLocation.altitude + 0.0);
    double timezone = initialLocation.utcOffset;

    // Generate prayer times for one day on April 12th, 2018.
    prayers = Prayers.on(
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
//      print('Something');
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
      } else if (when30.isBefore(prayers.sunrise) ||
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

//      print("Current Prayer $currentPrayerName   $currentPrayer");
    });
  }

  Widget _buildTableCalendar() {
    DaysOfWeekStyle daysOfWeekStyle = new DaysOfWeekStyle(
      weekdayStyle: TextStyle().copyWith(color: Colors.white, fontSize: 12.0),
      weekendStyle: TextStyle().copyWith(color: Colors.white, fontSize: 12.0),
    );
    return Container(
      color: lightBlack,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 16.0),
        child: TableCalendar(
          calendarController: _calendarController,
          initialCalendarFormat: CalendarFormat.week,
          availableGestures: AvailableGestures.horizontalSwipe,
          startingDayOfWeek: StartingDayOfWeek.monday,
          daysOfWeekStyle: daysOfWeekStyle,
          headerVisible: true,
          calendarStyle: CalendarStyle(
            selectedColor: Colors.white,
            todayColor: Colors.deepOrange[700],
            markersColor: Colors.brown[700],
            renderSelectedFirst: true,
            highlightSelected: true,
            contentPadding: EdgeInsets.all(0),
            outsideDaysVisible: true,
            renderDaysOfWeek: false,
            todayStyle:
                TextStyle().copyWith(color: Colors.white, fontSize: 12.0),
            holidayStyle:
                TextStyle().copyWith(color: Colors.white, fontSize: 12.0),
            weekendStyle:
                TextStyle().copyWith(color: Colors.white, fontSize: 12.0),
            weekdayStyle:
                TextStyle().copyWith(color: Colors.white, fontSize: 12.0),
            selectedStyle:
                TextStyle().copyWith(color: Colors.black, fontSize: 12.0),
            outsideWeekendStyle:
                TextStyle().copyWith(color: Colors.white, fontSize: 12.0),
          ),
          headerStyle: HeaderStyle(
              formatButtonTextStyle:
                  TextStyle().copyWith(color: Colors.white, fontSize: 12.0),
              formatButtonDecoration: BoxDecoration(
                color: Colors.deepOrange[400],
                borderRadius: BorderRadius.circular(16.0),
              ),
              titleTextStyle:
                  TextStyle().copyWith(color: Colors.white, fontSize: 14.0),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: Colors.white,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
              formatButtonVisible: false,
              centerHeaderTitle: true,
              headerPadding: EdgeInsets.all(0),
              formatButtonShowsNext: true),
          onDaySelected: _onDaySelected,
          onVisibleDaysChanged: _onVisibleDaysChanged,
        ),
      ),
    );
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');

    slidePrayerControler.reverse().then<dynamic>((data) async {
      if (!mounted) {
        return;
      }
      slidePrayerControler.forward();

      if ((day.day == DateTime.now().day &&
          day.month == DateTime.now().month &&
          day.year == DateTime.now().year)) {
        daySelectedStatus = true;
      } else {
        daySelectedStatus = false;
      }
      calenderDate = new ummAlquraCalendar.fromDate(day);

      CalculationMethodPreset calculationMethodPreset = prayerConsts
          .calculationMethord[selectedCalcMethordPos].calculationMethodPreset;

      JuristicMethodPreset juristicMethodPresets = prayerConsts
          .juristicMethord[selectedAsrJuristicMethordPos].juristicMethodPreset;

      HighLatitudeAdjustment highLatitudeAdjustment = prayerConsts
          .higherLatitude[selectedHigherLatitudeMethordPos]
          .higherAltitudePresent;

      PrayerCalculationSettings settings = PrayerCalculationSettings(
          (PrayerCalculationSettingsBuilder b) => b
            ..imsakParameter.value = -10.0
            ..imsakParameter.type = PrayerCalculationParameterType.minutesAdjust
            ..calculationMethod.replace(CalculationMethod.fromPreset(
                preset: calculationMethodPreset, when: DateTime.now().toUtc()))
            ..juristicMethod.replace(
                JuristicMethod.fromPreset(preset: juristicMethodPresets))
            ..highLatitudeAdjustment = highLatitudeAdjustment
            ..imsakMinutesAdjustment = 0
            ..fajrMinutesAdjustment = adjestTime[1].toInt()
            ..sunriseMinutesAdjustment = adjestTime[6].toInt()
            ..dhuhaMinutesAdjustment = 0
            ..dhuhrMinutesAdjustment = adjestTime[2].toInt()
            ..asrMinutesAdjustment = adjestTime[3].toInt()
            ..maghribMinutesAdjustment = adjestTime[4].toInt()
            ..ishaMinutesAdjustment = adjestTime[5].toInt());

      // Init location info.

      geo = Geocoordinate((GeocoordinateBuilder b) => b
        ..latitude = initialLocation.latitude
        ..longitude = initialLocation.longitude
        ..altitude = initialLocation.altitude + 0.0);
      double timezone = initialLocation.utcOffset;

      DateTime when = DateTime.now();

      if (daySelectedStatus) {
        prayers = Prayers.on(
            date: day, settings: settings, coordinate: geo, timeZone: timezone);
      } else {
        selectedPrayer = Prayers.on(
            date: day, settings: settings, coordinate: geo, timeZone: timezone);
      }

      prevPrayerPos = currentPrayerPos;
      currentPrayerPos = 0;

      setState(() {});
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');

//    print(_today.toFormat("dd MMMM yyyy"));
  }

//  Future<List<DropdownMenuItem>> getLocationList(
//      LocationHelper dbHelper) async {
//    List<DropdownMenuItem> gLocation = [];
//    await dbHelper.getAllLocations().then((value) {
//      int i = 0;
//      for (Location location in value) {
//        gLocation.add(DropdownMenuItem(
//          child: Text(location.cityName),
//          value: location.cityName,
//        ));
//        i++;
//      }
//    });
//    return gLocation;
////    List<DuaHeading> dua =
////    await Provider.of<DuaHeadingHelper>(context, listen: true)
////        .getFavoriteData();
//
////    return dua;
//  }

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  var textController;

  double get widthButtonCancel {
    textController.text?.isEmpty ?? true ? 0 : 50;
  }

  Future<void> _openFilteredCountryPickerDialog(BuildContext context) async {
    List<Location> locations = [];
    locations.add(initialLocation);
    _locationStream.sink.add(locations);
    textController = TextEditingController();
    _focus = FocusNode();
    _focus.addListener(_onFocusChange);
    if (_timer1 != null) {
      _timer1.cancel();
    }
    _timer1 = Timer(
      Duration(milliseconds: 500),
      () {
        setState(() {
          query = textController.text;
        });
        getSearchData(name: textController.text, context: context);
        Provider.of<LocationHelper>(
          context,
          listen: false,
        ).searchLocaiton(query: textController.text);
      },
    );

    showDialog(
        context: context,
        builder: (contexts) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 16,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              child: CustomScrollView(

                physics: AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
//                                SliverAppBar(
//                                  backgroundColor: whitebg,
//                                  floating: true,
//                                  snap: true,
//                                  pinned: true,
//                                  flexibleSpace:
//                                ),

                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      minHeight: isShrink ? 110.0 : 70,
                      maxHeight: isShrink ? 110.0 : 70.0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 16.0, right: 8.0, left: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: 50,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TypeAheadFormField(
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                              decoration: InputDecoration(
                                                fillColor: Colors.black,
                                                hintText: "Search Location",
                                                enabledBorder: InputBorder.none,
                                                border: InputBorder.none,
                                              ),
                                              controller: textController,
                                              focusNode: _focus),
                                      suggestionsCallback: (String pattern) {
                                        return List();
                                      },
                                      errorBuilder: (context, suggestion) {
                                        return SizedBox();
                                      },
                                      noItemsFoundBuilder: (context) {
                                        return SizedBox();
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text(suggestion),
                                        );
                                      },
                                      transitionBuilder: _transitionBuilder,
                                      onSuggestionSelected: (suggestion) {
                                        FocusScope.of(context).requestFocus(
                                            FocusNode()); //dismiss keyboard

                                        if (suggestion != textController.text) {
                                          setState(() {
                                            textController.text = suggestion;
                                          });
                                          setState(() {
                                            query = textController.text;
                                          });
                                          Provider.of<LocationHelper>(
                                            context,
                                            listen: false,
                                          ).searchLocaiton(
                                              query: textController.text);
                                          getSearchData(
                                              name: textController.text,
                                              context: context);
                                        }
                                      },
                                    ),
                                  ),
                                  AnimatedContainer(
                                    width: widthButtonCancel,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          textController.text = "";
                                          isVisibleSearch = false;
                                        });
                                        textController.text = "";
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                      },
                                      child: Center(
                                          child: widthButtonCancel == 0
                                              ? Container()
                                              : Icon(Icons.cancel)

//                      Text(
//                        S.of(context).cancelx,
//                        overflow: TextOverflow.ellipsis,
//                      ),

                                          ),
                                    ),
                                    duration: Duration(milliseconds: 200),
                                  ),
                                  AnimatedContainer(
                                    width: widthButtonCancel == 0 ? 50 : 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          textController.text = "";
                                          isVisibleSearch = false;
                                        });
                                        textController.text = "";
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                      },
                                      child: IconButton(
                                        iconSize: 20,
                                        icon: Icon(FeatherIcons.search,
                                            color: Colors.black),
                                        onPressed: () {},
                                      ),
                                    ),
                                    duration: Duration(milliseconds: 200),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
//                                SliverFixedExtentList(
//                                    itemExtent: 150.0,
//                                    delegate: SliverChildListDelegate([
//
//                                    ])),

                  StreamBuilder<List<Location>>(
                      stream: _locationStream.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
//                          return SliverAnimatedList(
//                            key: _listKey,
//                            initialItemCount: snapshot.data.length,
//                            itemBuilder: (BuildContext context, int index, Animation animation) {
//                              return FadeTransition(
//                                opacity: animation,
//                                child: ListTile(
//                                  title: Text(snapshot.data[index].cityName),
//                                  subtitle: Text(snapshot.data[index].countryCode),
//
//                                  onLongPress: () {
//                                    //TODO: Delete user
//                                  },
//                                ),
//                              );
//                            },
//                          );

                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return AnimatedBuilder(
                                  animation: ColorTween(
                                          begin: Colors.white,
                                          end: Color(0xff1b305d))
                                      .animate(_ColorAnimationController1),
                                  builder:
                                      (BuildContext context, Widget child) {
                                    return ListTile(
                                      title:
                                          Text(snapshot.data[index].cityName),
                                      subtitle: Text(
                                          snapshot.data[index].countryCode),
                                      onTap: () {
                                        Navigator.pop(context);
                                        onLocationChanged(snapshot.data[index]);
                                        initialLocation = snapshot.data[index];
                                        setState(() {});
                                      },
                                      onLongPress: () {
                                        //TODO: Delete user
                                      },
                                    );
                                  });
                            }, childCount: snapshot.data.length),
                          );
                        } else {
                          return SliverToBoxAdapter(
                            child: Container(
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          );
                        }
                      }),
                  SliverToBoxAdapter(
                      child: Container(
                    height: 80,
                  ))
                ],
              ),
            ),
          );
        });
  }

  Widget _transitionBuilder(BuildContext context, Widget suggestionsBox,
      AnimationController controller) {
    if (_timer1 != null) {
      _timer1.cancel();
    }
    _timer1 = Timer(
      Duration(milliseconds: 500),

      () {
        setState(() {
          query = textController.text;
        });
        Provider.of<LocationHelper>(
          context,
          listen: false,
        ).searchLocaiton(query: textController.text);
      },
    );
    getSearchData(name: textController.text, context: context);
    return suggestionsBox;
  }

  Future<void> onLocationChanged(Location location) async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setDouble("latitude", location.latitude);
      sharedPreferences.setDouble("longitude", location.longitude);
      sharedPreferences.setInt("altitude", location.altitude);
      sharedPreferences.setDouble("utcOffset", location.utcOffset);
      sharedPreferences.setString("cityName", location.cityName);
      sharedPreferences.setString("timezone", location.timezone);
      sharedPreferences.setString("countryCode", location.countryCode);
    });
    CalculationMethodPreset calculationMethodPreset = prayerConsts
        .calculationMethord[selectedCalcMethordPos].calculationMethodPreset;

    JuristicMethodPreset juristicMethodPresets = prayerConsts
        .juristicMethord[selectedAsrJuristicMethordPos].juristicMethodPreset;

    HighLatitudeAdjustment highLatitudeAdjustment = prayerConsts
        .higherLatitude[selectedHigherLatitudeMethordPos].higherAltitudePresent;

    PrayerCalculationSettings settings = PrayerCalculationSettings(
        (PrayerCalculationSettingsBuilder b) => b
          ..imsakParameter.value = -10.0
          ..imsakParameter.type = PrayerCalculationParameterType.minutesAdjust
          ..calculationMethod.replace(CalculationMethod.fromPreset(
              preset: calculationMethodPreset, when: DateTime.now().toUtc()))
          ..juristicMethod
              .replace(JuristicMethod.fromPreset(preset: juristicMethodPresets))
          ..highLatitudeAdjustment = highLatitudeAdjustment
          ..imsakMinutesAdjustment = 0
          ..fajrMinutesAdjustment = adjestTime[1].toInt()
          ..sunriseMinutesAdjustment = adjestTime[6].toInt()
          ..dhuhaMinutesAdjustment = 0
          ..dhuhrMinutesAdjustment = adjestTime[2].toInt()
          ..asrMinutesAdjustment = adjestTime[3].toInt()
          ..maghribMinutesAdjustment = adjestTime[4].toInt()
          ..ishaMinutesAdjustment = adjestTime[5].toInt());

    // Init location info.

    geo = Geocoordinate((GeocoordinateBuilder b) => b
      ..latitude = location.latitude
      ..longitude = location.longitude
      ..altitude = location.altitude + 0.0);
    double timezone = location.utcOffset;

    DateTime when = DateTime.now();
    prayers = Prayers.on(
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
    prevPrayerPos = currentPrayerPos;
    currentPrayerPos = 0;
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => minHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
//    return maxHeight != oldDelegate.maxHeight ||
//        minHeight != oldDelegate.minHeight ||
//        child != oldDelegate.child;
  }
}
