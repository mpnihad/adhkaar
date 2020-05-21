import 'dart:ui';

import 'package:adhkaar/audio/Audiowidgte.dart';
import 'package:adhkaar/database/helper/Helper.dart';
import 'package:adhkaar/database/model/Dua.dart';
import 'package:adhkaar/database/model/Duaheading.dart';
import 'package:adhkaar/database/modelhelper/DuaHelper.dart';
import 'package:adhkaar/utils/colors.dart';
import 'package:adhkaar/utils/numberdart.dart';
import 'package:adhkaar/utils/stagewiget.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:share/share.dart';

class DetailPage extends StatefulWidget {
  DetailPage({@required this.duaHeading,this.positions=0, Key key}) : super(key: key);

  final DuaHeading duaHeading;
  final int positions;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  ScrollController scrollController;
  PageController pageController;
  AnimationController animationBar;
  DuaHelper helper;
  AnimationController scaleAnimation;
  AnimationController animationController, animationController_initial;
  bool _menuShown = false;
  double textSize;
  int count;
  int tabPos;
  int page;
  int position;
  int prevposition;

  Future<List<Dua>> Duas;

  @override
  void initState() {
    var dbHelper = Helper();
    helper = DuaHelper(dbHelper.db);

    Duas = getAllDuas(helper);
    position = 0;
    textSize = 11;
    scaleAnimation = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000),
        lowerBound: 0.0,
        upperBound: 1.0);
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    animationController_initial = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    tabPos = 0;
    count = 1;

    animationBar =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100))
          ..addListener(() {});

    scaleAnimation.forward();

    scrollController = ScrollController();
    pageController = PageController();

    scrollController.addListener(() {
      ScrollPosition position = scrollController.position;
//      ScrollDirection direction = position.userScrollDirection;
//      page = position.pixels ~/
//          (position.maxScrollExtent / (todos.length.toDouble() - 1));
//      double pageDo = (position.pixels /
//          (position.maxScrollExtent / (todos.length.toDouble() - 1)));
//      double percent = pageDo - page;
//
//      if (todos.length - 1 < page + 1) {
//        return;
//      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    animationBar.dispose();
    animationController.dispose();
    animationController_initial.dispose();
    scaleAnimation.dispose();
    scrollController.dispose();
    pageController.dispose();
  }

  void updateBarPercent() async {
    if (animationBar.status == AnimationStatus.forward ||
        animationBar.status == AnimationStatus.completed) {
      await animationBar.reverse();
    } else {
      await animationBar.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    animationController_initial.forward();
    Animation opacityAnimation =
        Tween(begin: 0.0, end: 1.0).animate(animationController);
    if (_menuShown)
      animationController.forward();
    else
      animationController.reverse();
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0.0),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: AnimatedBuilder(
                animation: animationController_initial,
                builder: (context, snapshot) {
                  return FadeTransition(
                    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: animationController_initial,
                            curve: Curves.fastOutSlowIn)),
                    child:
//
                        ScaleTransition(
                      scale: CurvedAnimation(
                          parent: animationController_initial,
                          curve: Curves.ease),
                      child: Material(
                        color: Colors.transparent,
                        type: MaterialType.transparency,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          color: Colors.black,
                          onPressed: () {
                            animationController_initial.duration =
                                Duration(milliseconds: 500);
                            animationController_initial
                                .reverse()
                                .then<dynamic>((data) async {
                              if (!mounted) {
                                return;
                              }
                              animationController_initial.duration =
                                  Duration(milliseconds: 1500);
                              Navigator.of(context).pop();
                            });
                          },
                        ),
                      ),
                    ),
                  );
                }),

//            flexibleSpace: FlexibleSpaceBar(
//              centerTitle: true,
//
//              titlePadding: const EdgeInsets.only(
//                  left: 60.0, right: 60.0,top: 20),
//              collapseMode: CollapseMode.parallax,
//              title: Container(
//              child: Text(
//                  widget.todoObject.title,
//                  textAlign: TextAlign.center,
//                  style: TextStyle(
//                      fontFamily: "Butler",
//                      fontSize: 17,
//                      fontWeight: FontWeight.w500,
//                      color:widget.todoObject.color
//                  )),
//            ),
//              ),

            actions: <Widget>[
              Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _menuShown = !_menuShown;
                      });
//                  return Center(
//                      child: Container(
//                    decoration: ShapeDecoration(
//                      color: Colors.red,
//                      shape: TooltipShapeBorder(arrowArc: 0.5),
//                      shadows: [
//                        BoxShadow(
//                            color: Colors.black26,
//                            blurRadius: 4.0,
//                            offset: Offset(2, 2))
//                      ],
//                    ),
//                    child: Padding(
//                      padding: EdgeInsets.all(16.0),
//                      child: Text('Text 22',
//                          style: TextStyle(color: Colors.white)),
//                    ),
//                  ));
//                  SuperTooltip(
//                      popupDirection: TooltipDirection.left,
//                      top: 150.0,
//                      left: 30.0,
//                      arrowTipDistance: 10.0,
//                      showCloseButton: ShowCloseButton.inside,
//                      closeButtonColor: Colors.black,
//                      closeButtonSize: 30.0,
//                      hasShadow: false,
//                      touchThrougArea: new Rect.fromCircle(center:Offset.zero, radius: 40.0),
//                  content: new Material(
//                  child: Padding(
//                  padding: const EdgeInsets.only(top:20.0),
//                  child: Text(
//                  "Lorem ipsum dolor sit amet, consetetursadipscing elitr, "
//                  "sed diam nonumy eirmod tempor invidunt utlabore et dolore magna aliquyam erat, "
//                  "sed diam voluptua. At vero eos et accusam etjusto duo dolores et ea rebum. ",
//                  softWrap: true,
//                  ),
//                  ))).show(context);
                    },
                    child: AnimatedBuilder(
                        animation: animationController_initial,
                        builder: (context, snapshot) {
                          return FadeTransition(
                            opacity: Tween<double>(begin: 0.0, end: 1.0)
                                .animate(CurvedAnimation(
                                    parent: animationController_initial,
                                    curve: Curves.fastOutSlowIn)),
                            child:
//
                                ScaleTransition(
                              scale: CurvedAnimation(
                                  parent: animationController_initial,
                                  curve: Curves.ease),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, right: 10.0),
                                child: Column(
                                  children: <Widget>[
                                    Material(
                                        color: Colors.transparent,
                                        type: MaterialType.transparency,
                                        child: Text(
                                          "+ Aa -",
                                          style: TextStyle(
                                              fontFamily: "Moon",
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  Positioned(
                    child: FadeTransition(
                        opacity: opacityAnimation,
                        child:
//                  _ShapedWidget(
//                    onlyTop: true,
//                    value:textSize
//                  ),
                            Container(
                          padding: const EdgeInsets.only(top: 50.0, right: 0.0),
                          child: Center(
                            child: Material(
                                clipBehavior: Clip.antiAlias,
                                shape: ShapedWidgetBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                    padding: 4.0),
                                elevation: 0.0,
                                child: Container(
                                  padding: EdgeInsets.all(4.0)
                                      .copyWith(bottom: 4.0 * 2),
                                  child: true
                                      ? SizedBox(
                                          width: 150.0,
                                          height: 20.0,
                                        )
                                      : SizedBox(
                                          width: 150.0,
                                          height: 150.0,
                                          child: Center(
                                            child: Slider(
                                              value: textSize,
                                              onChanged: (newRating) {
                                                setState(
                                                    () => textSize = newRating);
                                              },
                                              divisions: 4,
                                            ),
                                          ),
                                        ),
                                )),
                          ),
                        )),
                    right: 20.0,
                    top: 48.0,
                  ),
                ],
              ),

//              Hero(
//                tag: widget.todoObject.uuid + "_more_vert",
//                child: Material(
//                  color: Colors.transparent,
//                  type: MaterialType.transparency,
//                  child: PopupMenuButton(
//                    icon: Icon(
//                      Icons.more_vert,
//                      color: Colors.grey,
//                    ),
//                    itemBuilder: (context) => <PopupMenuEntry<TodoCardSettings>>[
//                      PopupMenuItem(
//                        child: Text("Edit Color"),
//                        value: TodoCardSettings.edit_color,
//                      ),
//                      PopupMenuItem(
//                        child: Text("Delete"),
//                        value: TodoCardSettings.delete,
//                      ),
//                    ],
//                    onSelected: (setting) {
//                      switch (setting) {
//                        case TodoCardSettings.edit_color:
//                          print("edit color clicked");
//                          break;
//                        case TodoCardSettings.delete:
//                          print("delete clicked");
//                          break;
//                      }
//                    },
//                  ),
//                ),
//              ),
            ],
          ),
          body: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              FutureBuilder<List<Dua>>(
                  future: Duas,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      count = snapshot.data[position].todaysCount;
                      return Column(
                        children: <Widget>[
                          AnimatedBuilder(
                              animation: animationController_initial,
                              builder: (context, snapshot) {
                                return FadeTransition(
                                  opacity: Tween<double>(begin: 0.0, end: 1.0)
                                      .animate(CurvedAnimation(
                                          parent: animationController_initial,
                                          curve: Curves.fastOutSlowIn)),
                                  child:
//
                                      ScaleTransition(
                                    scale: CurvedAnimation(
                                        parent: animationController_initial,
                                        curve: Curves.ease),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Hero(
                                        tag: widget.duaHeading.id.toString() +
                                            "_title",
                                        flightShuttleBuilder:
                                            _flightShuttleBuilder,
                                        transitionOnUserGestures: true,
                                        child: SizedBox(
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                              widget.duaHeading.name,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  shadows: <Shadow>[
                                                    Shadow(
                                                      offset: Offset(0.2, 0.2),
                                                      blurRadius: 1.0,
                                                      color: Colors.black54,
                                                    ),
                                                  ],
                                                  fontFamily: "Kartika",
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      widget.duaHeading.pallet),
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          AnimatedBuilder(
                              animation: animationController_initial,
                              builder: (context, snapshots) {
                                return FadeTransition(
                                  opacity: Tween<double>(begin: 0.0, end: 1.0)
                                      .animate(CurvedAnimation(
                                          parent: animationController_initial,
                                          curve: Curves.fastOutSlowIn)),
                                  child:
//
                                      ScaleTransition(
                                    scale: CurvedAnimation(
                                        parent: animationController_initial,
                                        curve: Curves.ease),
                                    child: SizedBox(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Digit<int>(
                                            padding: EdgeInsets.only(),
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                shape: BoxShape.circle),
                                            textStyle: TextStyle(
                                                fontSize: 50,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontFamily: "Moon"),
                                            id: (position + 1).toString(),
                                          ),
                                          Text(
                                            "/" +
                                                snapshot.data.length.toString(),
                                            style: TextStyle(
                                              fontSize: 50,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Moon",
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.height - 50 - 146,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 00.0, right: 0.0, top: 15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        AnimatedBuilder(
                                            animation:
                                                animationController_initial,
                                            builder: (context, snapshot) {
                                              return FadeTransition(
                                                opacity: Tween<double>(
                                                        begin: 0.0, end: 1.0)
                                                    .animate(CurvedAnimation(
                                                        parent:
                                                            animationController_initial,
                                                        curve: Curves.ease)),
                                                child: new Transform(
                                                  transform: new Matrix4
                                                          .translationValues(
                                                      -30 *
                                                          (1.0 -
                                                              Tween<double>(
                                                                      begin:
                                                                          0.0,
                                                                      end: 1.0)
                                                                  .animate(CurvedAnimation(
                                                                      parent:
                                                                          animationController_initial,
                                                                      curve: Curves
                                                                          .fastOutSlowIn))
                                                                  .value),
                                                      0.0,
                                                      0.0),
//                                                  new Matrix4.translationValues(
//                                                      30 *
//                                                          (1.0 -
//                                                              Tween<double>(begin: 0.0, end: 1.0)
//                                                                  .animate(CurvedAnimation(
//                                                                  parent:
//                                                                  animationController_initial,
//                                                                  curve: Curves.ease))
//                                                                  .value),
//                                                      0.0,
//                                                      0.0),

                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 300,
                                                    width: 60,
                                                    child: RotatedBox(
                                                        quarterTurns: 3,
                                                        child:
                                                            DefaultTabController(
                                                          child: TabBar(
                                                            tabs: [
                                                              Tab(
                                                                child: Text(
                                                                  "Arabic",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "Moon",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: tabPos ==
                                                                              0
                                                                          ? lightBlack
                                                                          : lightGrey),
                                                                ),
                                                              ),
                                                              Tab(
                                                                child: Text(
                                                                  "Transilation",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "Moon",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: tabPos ==
                                                                              1
                                                                          ? lightBlack
                                                                          : lightGrey),
                                                                ),
                                                              ),
                                                            ],
                                                            indicator:
                                                                BoxDecoration(
                                                                    border:
                                                                        Border(
                                                              top: BorderSide(
                                                                color: Theme.of(
                                                                        context)
                                                                    .accentColor,
                                                                width: 5.0,
                                                              ),
                                                            )),
                                                            indicatorPadding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            labelPadding:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            onTap: (pos) {
                                                              setState(() {
                                                                tabPos = pos;
                                                              });
                                                            },
                                                          ),
                                                          length: 2,
                                                        )),
                                                  ),
                                                ),
                                              );
                                            }),
                                        Expanded(
                                          child: AnimatedBuilder(
                                              animation:
                                                  animationController_initial,
                                              builder: (context, snapshot) {
                                                return FadeTransition(
                                                  opacity: Tween<double>(
                                                          begin: 0.0, end: 1.0)
                                                      .animate(CurvedAnimation(
                                                          parent:
                                                              animationController_initial,
                                                          curve: Curves
                                                              .fastOutSlowIn)),
                                                  child:
//
                                                      ScaleTransition(
                                                    scale: CurvedAnimation(
                                                        parent:
                                                            animationController_initial,
                                                        curve: Curves.ease),
                                                    child:
                                                        FutureBuilder<
                                                                List<Dua>>(
                                                            future: Duas,
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                  .hasData) {

                                                                return PageView
                                                                    .builder(
                                                                  itemBuilder:
                                                                      (context,
                                                                          position) {


                                                                    Dua dua = snapshot
                                                                            .data[
                                                                        position];

                                                                    return Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              10.0,
                                                                          right:
                                                                              10.0,
                                                                          bottom:
                                                                              30.0,
                                                                          top:
                                                                              10),
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () {
//                                            Navigator.of(context).push(
//                                              PageRouteBuilder(
//                                                pageBuilder: (BuildContext
//                                                            context,
//                                                        Animation<double>
//                                                            animation,
//                                                        Animation<double>
//                                                            secondaryAnimation) =>
//                                                    DetailPage(
//                                                        todoObject: todoObject),
//                                                transitionDuration: Duration(
//                                                    milliseconds: 1000),
//                                              ),
//                                            );
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                              boxShadow: [
                                                                                BoxShadow(color: Colors.black.withAlpha(70), offset: Offset(3.0, 10.0), blurRadius: 15.0)
                                                                              ]),
                                                                          height:
                                                                              250.0,
                                                                          child:
                                                                              Stack(
                                                                            children: <Widget>[
                                                                              Hero(
                                                                                tag: dua.id.toString() + "_background1",
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.white,
                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Column(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.only(top: 16, bottom: 10, left: 16, right: 5),
                                                                                      child: Scrollbar(
                                                                                        child: SingleChildScrollView(
                                                                                          physics: AlwaysScrollableScrollPhysics(),
                                                                                          child: Padding(
                                                                                            padding: EdgeInsets.only(right: 11),
                                                                                            child: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              children: <Widget>[
                                                                                                dua.duaHeader == ""
                                                                                                    ? SizedBox()
                                                                                                    : Padding(
                                                                                                        padding: const EdgeInsets.only(bottom: 8.0),
                                                                                                        child: Material(
                                                                                                            color: Colors.transparent,
                                                                                                            child: Text(
                                                                                                              dua.duaHeader == "no" ? "" : dua.duaHeader,
                                                                                                              style: TextStyle(fontSize: textSize),
                                                                                                              textDirection: TextDirection.ltr,
                                                                                                            )),
                                                                                                      ),
                                                                                                Neumorphic(
                                                                                                  boxShape: NeumorphicBoxShape.roundRect(borderRadius: BorderRadius.circular(4)),
                                                                                                  padding: EdgeInsets.all(0),
                                                                                                  style: NeumorphicStyle(shape: NeumorphicShape.flat, depth: 3, intensity: .5, lightSource: LightSource.left, color: whitebg, shadowLightColor: Colors.white, shadowDarkColor: Colors.white),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                                    child: Column(
                                                                                                      children: <Widget>[
                                                                                                        Container(
                                                                                                          width: MediaQuery.of(context).size.width - 60,
                                                                                                          child: Material(
                                                                                                            color: Colors.transparent,
                                                                                                            child: tabPos == 0
                                                                                                                ? Text(
                                                                                                                    dua.duaAr == "no" || dua.duaAr == "-" ? "" : dua.duaAr,
                                                                                                                    style: TextStyle(fontSize: textSize + 3),
                                                                                                                    textDirection: TextDirection.rtl,
                                                                                                                  )
                                                                                                                : dua.duaTrans == "no" || dua.duaTrans == "" || dua.duaTrans == "-"
                                                                                                                    ? Text(
                                                                                                                        dua.duaAr,
                                                                                                                        style: TextStyle(fontSize: textSize + 3),
                                                                                                                        textDirection: TextDirection.rtl,
                                                                                                                      )
                                                                                                                    : Text(
                                                                                                                        dua.duaTrans,
                                                                                                                        style: TextStyle(fontSize: textSize, fontStyle: FontStyle.italic),
                                                                                                                        textDirection: TextDirection.ltr,
                                                                                                                      ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        dua.duaTr == "no" || dua.duaTr == "" || dua.duaTr == "-"
                                                                                                            ? SizedBox()
                                                                                                            : Divider(
                                                                                                                thickness: 1,
                                                                                                              ),
                                                                                                        dua.duaTr == "no" || dua.duaTr == "" || dua.duaTr == "-"
                                                                                                            ? SizedBox()
                                                                                                            : Material(
                                                                                                                color: Colors.transparent,
                                                                                                                child: Text(
                                                                                                                  dua.duaTr == "no" ? "" : dua.duaTr,
                                                                                                                  style: TextStyle(
                                                                                                                    fontSize: textSize,
                                                                                                                    fontWeight: FontWeight.w500,
                                                                                                                    wordSpacing: 5,
                                                                                                                    letterSpacing: .5,
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                !dua.showflag || (dua.duaMiddle == "" && dua.duaAr2 == "" && dua.duaTr2 == "" && dua.duaTrans2 == "" && dua.duaFooter == "")
                                                                                                    ? SizedBox()
                                                                                                    : Divider(
                                                                                                        thickness: 1,
                                                                                                      ),
                                                                                                !dua.showflag || dua.duaMiddle == "no" || dua.duaMiddle == ""
                                                                                                    ? SizedBox()
                                                                                                    : Container(
                                                                                                        padding: EdgeInsets.only(bottom: 8.0),
                                                                                                        width: MediaQuery.of(context).size.width - 60,
                                                                                                        child: Material(
                                                                                                            color: Colors.transparent,
                                                                                                            child: Text(
                                                                                                              dua.duaMiddle == "no" ? "" : dua.duaMiddle,
                                                                                                              style: TextStyle(fontSize: textSize),
                                                                                                              textDirection: TextDirection.ltr,
                                                                                                            )),
                                                                                                      ),
                                                                                                !dua.showflag
                                                                                                    ? SizedBox()
                                                                                                    : (((dua.duaAr2 == "no" || dua.duaAr2 == "") && (dua.duaTrans2 == "no" || dua.duaTrans2 == "") && (dua.duaTr2 == "no" || dua.duaTr2 == "")))
                                                                                                        ? SizedBox()
                                                                                                        : Padding(
                                                                                                            padding: EdgeInsets.only(bottom: 8.0),
                                                                                                            child: Neumorphic(
                                                                                                              boxShape: NeumorphicBoxShape.roundRect(borderRadius: BorderRadius.circular(4)),
                                                                                                              padding: EdgeInsets.all(0),
                                                                                                              style: NeumorphicStyle(shape: NeumorphicShape.flat, depth: 3, intensity: .5, lightSource: LightSource.left, color: whitebg, shadowLightColor: Colors.white, shadowDarkColor: Colors.white),
                                                                                                              child: Padding(
                                                                                                                padding: const EdgeInsets.all(8.0),
                                                                                                                child: Column(
                                                                                                                  children: <Widget>[
                                                                                                                    Container(
                                                                                                                      width: MediaQuery.of(context).size.width - 60,
                                                                                                                      child: Material(
                                                                                                                        color: Colors.transparent,
                                                                                                                        child: tabPos == 0
                                                                                                                            ? Text(
                                                                                                                                dua.duaAr2 == "no" ? "" : dua.duaAr2,
                                                                                                                                style: TextStyle(fontSize: textSize + 3),
                                                                                                                                textDirection: TextDirection.rtl,
                                                                                                                              )
                                                                                                                            : dua.duaTrans2 == "no" || dua.duaTrans2 == ""
                                                                                                                                ? Text(
                                                                                                                                    dua.duaAr2,
                                                                                                                                    style: TextStyle(fontSize: textSize + 3),
                                                                                                                                    textDirection: TextDirection.rtl,
                                                                                                                                  )
                                                                                                                                : Text(
                                                                                                                                    dua.duaTrans2,
                                                                                                                                    style: TextStyle(fontSize: textSize, fontStyle: FontStyle.italic),
                                                                                                                                    textDirection: TextDirection.ltr,
                                                                                                                                  ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    !dua.showflag || (dua.duaAr2 == "" && dua.duaTr2 == "" && dua.duaTrans2 == "" && dua.duaFooter == "")
                                                                                                                        ? SizedBox()
                                                                                                                        : Divider(
                                                                                                                            thickness: 1,
                                                                                                                          ),
                                                                                                                    !dua.showflag || dua.duaTr2 == "no" || dua.duaTr2 == ""
                                                                                                                        ? SizedBox()
                                                                                                                        : Material(
                                                                                                                            color: Colors.transparent,
                                                                                                                            child: Text(
                                                                                                                              dua.duaTr2 == "no" ? "" : dua.duaTr2,
                                                                                                                              style: TextStyle(
                                                                                                                                fontSize: textSize,
                                                                                                                                fontWeight: FontWeight.w500,
                                                                                                                                wordSpacing: 5,
                                                                                                                                letterSpacing: .5,
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                  ],
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                !dua.showflag || dua.duaFooter == "no" || dua.duaFooter == ""
                                                                                                    ? SizedBox()
                                                                                                    : Material(
                                                                                                        color: Colors.transparent,
                                                                                                        child: Text(
                                                                                                          dua.duaFooter == "no" ? "" : dua.duaFooter,
                                                                                                          style: TextStyle(
                                                                                                            fontSize: textSize,
                                                                                                            fontWeight: FontWeight.w500,
                                                                                                            wordSpacing: 5,
                                                                                                            letterSpacing: .5,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                (dua.duaMiddle == "" &&
                                                                                                    (dua.duaAr2 == "no" ||
                                                                                                        dua.duaAr2 == "")
                                                                                                    && (dua.duaTr2 == "no" ||
                                                                                                        dua.duaTr2 == "")
                                                                                                    && (dua.duaTrans2 == "no" ||
                                                                                                        dua.duaTrans2 == "")
                                                                                                    && dua.duaFooter == "")

                                                                                                    ? SizedBox()
                                                                                                    : InkWell(
                                                                                                        onTap: () {
                                                                                                          setState(() {
                                                                                                            dua.showflag = !dua.showflag;
                                                                                                          });
                                                                                                        },
                                                                                                        child: Padding(
                                                                                                          padding: const EdgeInsets.only(top: 8.0),
                                                                                                          child: Column(
                                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                            children: <Widget>[
                                                                                                              dua.showflag
                                                                                                                  ? SizedBox()
                                                                                                                  : Padding(
                                                                                                                      padding: const EdgeInsets.only(bottom: 3.0),
                                                                                                                      child: Text(
                                                                                                                        dua.duaMiddle + "\n" + dua.duaAr2 + dua.duaTr2 + dua.duaFooter,
                                                                                                                        textAlign: TextAlign.start,
                                                                                                                        style: TextStyle(
                                                                                                                          fontSize: textSize,
                                                                                                                        ),
                                                                                                                        softWrap: true,
                                                                                                                        overflow: TextOverflow.fade,
                                                                                                                        maxLines: 2,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                              dua.showflag
                                                                                                                  ? Text(
                                                                                                                      "Close",
                                                                                                                      style: TextStyle(color: Colors.blue),
                                                                                                                    )
                                                                                                                  : Text("Read More", style: TextStyle(color: Colors.blue))
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(bottom: 10.0),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: <Widget>[
                                                                                        Expanded(
                                                                                          child: Container(),
                                                                                        ),
                                                                                        Center(
                                                                                          child: LikeButton(
                                                                                            size: 20,
                                                                                            circleColor: CircleColor(start:Colors.blue, end: Colors.blue),
                                                                                            bubblesColor: BubblesColor(
                                                                                              dotPrimaryColor: Colors.blue,
                                                                                              dotSecondaryColor: Colors.blue,
                                                                                            ),
                                                                                            likeBuilder: (bool isLiked) {
                                                                                              if( isLiked)
                                                                                              {
                                                                                                updateLike(
                                                                                                    helper,
                                                                                                    snapshot
                                                                                                        .data[position]
                                                                                                        .id,
                                                                                                    "TRUE");
                                                                                                dua.duaFav="TRUE";


                                                                                              }
                                                                                              else
                                                                                              {
                                                                                                updateLike(
                                                                                                    helper,
                                                                                                    snapshot
                                                                                                        .data[position]
                                                                                                        .id,
                                                                                                    "FALSE");

                                                                                                dua.duaFav="FALSE";

                                                                                              }
                                                                                              return isLiked
                                                                                                  ?  Icon(
                                                                                                  FontAwesomeIcons.solidBookmark,
                                                                                                  color: Colors.red,
                                                                                                  size: 20)
                                                                                                  : Icon(
                                                                                                FontAwesomeIcons.bookmark,
                                                                                                color: Colors.black,
                                                                                                      size: 20,
                                                                                                    );
                                                                                            },
                                                                                            isLiked:dua.duaFav=="TRUE"?true:false,

                                                                                            padding: EdgeInsets.all(0),
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            likeCount: null,
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          width: 20,
                                                                                        ),
                                                                                        Builder(
                                                                                            builder: (BuildContext context) {
                                                                                            return Center(
                                                                                              child:  InkWell(

                                                                                                  onTap: () {


                                                                                                    String final_text;
                                                                                                    String shareText="\n"+
                                                                                                        dua.duaHeader == ""?"":(dua.duaHeader+"\n")+
                                                                                                    "-------------------------------------------------------------"+"\n";
                                                                                                        String shareText1= dua.duaAr == "no" || dua.duaAr == "-"?"":(dua.duaAr+"\n");
                                                                                                        String shareText2= dua.duaTr == "no" || dua.duaTr == "" || dua.duaTr == "-"?"":(dua.duaTr+"\n");
                                                                                                        String shareText3= dua.duaTrans == "no" || dua.duaTrans == "" || dua.duaTrans == "-"?"":(dua.duaTrans+"\n")+

                                                                                                        "-------------------------------------------------------------"+"\n";
                                                                                                        String shareText4= dua.duaMiddle == "no" || dua.duaMiddle == ""?"":(dua.duaMiddle+"\n")+
                                                                                                        "-------------------------------------------------------------"+"\n";
                                                                                                        String shareText5= dua.duaAr2 == "no" ?"":(dua.duaAr2+"\n");
                                                                                                        String shareText6= dua.duaTr2 == "no" || dua.duaTr2 == ""?"":dua.duaTr2+"\n";
                                                                                                        String shareText7= dua.duaTrans2 == "no" || dua.duaTrans2 == ""?"":dua.duaTrans2+"\n"+
                                                                                                        "-------------------------------------------------------------"+"\n";
                                                                                                        String shareText9= dua.duaFooter;
                                                                                                    ;
                                                                                                    final_text=shareText1+shareText2+shareText3+shareText4+shareText5+shareText6+shareText7+shareText9;
                                                                                                      Share.share(final_text,
                                                                                                          subject: widget.duaHeading.name,
                                                                                                         );
                                                                                                  },child: Icon(FeatherIcons.share, size: 20)),
                                                                                            );
                                                                                          }
                                                                                        ),
                                                                                        SizedBox(
                                                                                          width: 10,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Row(
                                                                                    children: <Widget>[
                                                                                      Expanded(
//                                                            width: MediaQuery.of(
//                                                                        context)
//                                                                    .size
//                                                                    .width -
//                                                                100 -
//                                                                108,
                                                                                          child: PlayerWidget(
                                                                                        url: snapshot.data[position].duaAudAr,
                                                                                        id:snapshot.data[position].id,
                                                                                        playStatus: snapshot.data[position].playStatus,
                                                                                      )),
                                                                                      SizedBox(
                                                                                        width: 10,
                                                                                      ),
                                                                                      Container(
                                                                                        child: SizedBox(
                                                                                          width: 88,
                                                                                          height: 40,
                                                                                          child: NeumorphicButton(
                                                                                            boxShape: NeumorphicBoxShape.roundRect(borderRadius: BorderRadius.circular(6)),
                                                                                            style: NeumorphicStyle(shape: NeumorphicShape.flat, depth: 8, intensity: .3, lightSource: LightSource.bottomRight, color: count != dua.totalCount ? Colors.lightBlue : blueGrey, shadowLightColor: Colors.black),
                                                                                            onClick: () {
                                                                                              setState(() {
                                                                                                if (count == dua.totalCount) {
                                                                                                  pageController.animateToPage(position == snapshot.data.length - 1 ? position : position + 1, duration: Duration(milliseconds: 1000), curve: Curves.ease);
                                                                                                } else {
                                                                                                  dua.todaysCount++;
                                                                                                  count++;
                                                                                                  if (count == dua.totalCount) {
                                                                                                    pageController.animateToPage(position == snapshot.data.length - 1 ? position : position + 1, duration: Duration(milliseconds: 1000), curve: Curves.ease);
                                                                                                  }
                                                                                                }
                                                                                              });
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "${count} / ${dua.totalCount}",
                                                                                              style: TextStyle(color: Colors.white, fontSize: 12),
                                                                                            )),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 10,
                                                                                      )
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  onPageChanged:
                                                                      (position) {
                                                                    prevposition =
                                                                        this.position;
                                                                    this.position =
                                                                        position;

                                                                    updateCount(
                                                                        helper,
                                                                        snapshot
                                                                            .data[prevposition]
                                                                            .id,
                                                                        count);
                                                                    count = snapshot
                                                                        .data[
                                                                            position]
                                                                        .todaysCount;
                                                                    int i = 0;
                                                                    for (Dua todo
                                                                        in snapshot
                                                                            .data) {
                                                                      if (position !=
                                                                          i) {
                                                                        snapshot
                                                                            .data[position]
                                                                            .playStatus = 0;
                                                                      } else {
                                                                        snapshot
                                                                            .data[position]
                                                                            .playStatus = 0;
                                                                      }
                                                                      i++;
                                                                    }

                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  controller:
                                                                      pageController,
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  physics:
                                                                      _CustomScrollPhysics(),
                                                                  pageSnapping:
                                                                      true,
                                                                  //  controller: scrollController,

                                                                  itemCount:
                                                                      snapshot
                                                                          .data
                                                                          .length,
                                                                );
                                                              } else {
                                                                return Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      SizedBox(
                                                                    height: 30,
                                                                    width: 30,
                                                                    child:
                                                                        CircularProgressIndicator(),
                                                                  ),
                                                                );
                                                              }
                                                            }),
                                                  ),
                                                );
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AnimatedBuilder(
                                      animation: animationController_initial,
                                      builder: (context, snapshots) {
                                        return FadeTransition(
                                          opacity: Tween<double>(
                                                  begin: 0.0, end: 1.0)
                                              .animate(CurvedAnimation(
                                                  parent:
                                                      animationController_initial,
                                                  curve: Curves.ease)),
                                          child: new Transform(
                                            transform: new Matrix4
                                                    .translationValues(
                                                30 *
                                                    (1.0 -
                                                        Tween<double>(
                                                                begin: 0.0,
                                                                end: 1.0)
                                                            .animate(CurvedAnimation(
                                                                parent:
                                                                    animationController_initial,
                                                                curve: Curves
                                                                    .ease))
                                                            .value),
                                                0.0,
                                                0.0),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 15.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Container(),
                                                  ),
                                                  RotationTransition(
                                                    turns:
                                                        new AlwaysStoppedAnimation(
                                                            45 / 360),
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 40,
                                                      child: Neumorphic(
                                                        boxShape: NeumorphicBoxShape
                                                            .roundRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                        style: NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .concave,
                                                            depth: 3,
                                                            intensity: .4,
                                                            lightSource:
                                                                LightSource
                                                                    .left,
                                                            color: position == 0
                                                                ? Colors.grey
                                                                : whitebg,
                                                            shadowLightColor:
                                                                whitebg,
                                                            shadowDarkColor:
                                                                Colors.black),
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: InkWell(
                                                            splashColor: Colors
                                                                .blueAccent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            onTap: () {
                                                              pageController.animateToPage(
                                                                  position == 0
                                                                      ? 0
                                                                      : position -
                                                                          1,
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          1000),
                                                                  curve: Curves
                                                                      .ease);
                                                            },
                                                            child:
                                                                RotationTransition(
                                                              turns:
                                                                  new AlwaysStoppedAnimation(
                                                                      -45 /
                                                                          360),
                                                              child: Icon(
                                                                Icons
                                                                    .navigate_before,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 30,
                                                  ),
                                                  RotationTransition(
                                                    turns:
                                                        new AlwaysStoppedAnimation(
                                                            45 / 360),
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 40,
                                                      child: Neumorphic(
                                                        boxShape: NeumorphicBoxShape
                                                            .roundRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        style: NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .concave,
                                                            depth: 3,
                                                            intensity: .5,
                                                            lightSource:
                                                                LightSource
                                                                    .left,
                                                            color: position ==
                                                                    snapshot.data
                                                                            .length -
                                                                        1
                                                                ? Colors.grey
                                                                : Colors.blue
                                                                    .withOpacity(
                                                                        0.8),
                                                            shadowLightColor:
                                                                Colors.white,
                                                            shadowDarkColor:
                                                                Colors.black),
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: InkWell(
                                                            splashColor:
                                                                Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child: RotationTransition(
                                                                turns:
                                                                    new AlwaysStoppedAnimation(
                                                                        -45 /
                                                                            360),
                                                                child: Icon(
                                                                    Icons
                                                                        .navigate_next,
                                                                    size: 20)),
                                                            onTap: () {
                                                              pageController.animateToPage(
                                                                  position ==
                                                                          snapshot.data.length -
                                                                              1
                                                                      ? position
                                                                      : position +
                                                                          1,
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          1000),
                                                                  curve: Curves
                                                                      .ease);
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      })
//                          Player(
//                            songData: songModel,
//                            downloadData: downloadModel,
//                            nowPlay: false,
//                          ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  }),
              Positioned(
                child: FadeTransition(
                    opacity: opacityAnimation,
                    child: Center(
                      child: Material(
                          clipBehavior: Clip.antiAlias,
                          shape: ShapedWidgetBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                              padding: 4.0),
                          elevation: 4.0,
                          child: Container(
                            padding:
                                EdgeInsets.all(4.0).copyWith(bottom: 4.0 * 2),
                            child: false
                                ? SizedBox(
                                    width: 150.0,
                                    height: 20.0,
                                  )
                                : SizedBox(
                                    width: 190.0,
                                    height: 50.0,
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(
                                              width: 30,
                                              child: FlatButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (textSize != 0) {
                                                      textSize--;
                                                    }
                                                  });
                                                },
                                                padding: EdgeInsets.all(2),
                                                child: Text("A",
                                                    style: TextStyle(
                                                        fontFamily: "Moon",
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ),
                                            ),
//                                            Expanded(
//                                              flex: 10,
//                                              child: Container(
//                                                padding:
//                                                    EdgeInsets.only(left: 0),
//                                                child: GestureDetector(
//                                                  onTap: () {
//
//                                                  },
//                                                  onLongPressEnd: (info) {
//                                                    setState(() {
//                                                      if (textSize != 0) {
//                                                        textSize--;
//                                                      }
//                                                    });
//                                                  },
//                                                  onDoubleTap: () {
//                                                    setState(() {
//                                                      if (textSize != 0) {
//                                                        textSize--;
//                                                      }
//                                                    });
//                                                  },
//                                                  child: Container(
//                                                    child: Text("A",
//                                                        style: TextStyle(
//                                                            fontFamily: "Moon",
//                                                            fontSize: 15,
//                                                            fontWeight:
//                                                                FontWeight
//                                                                    .w600)),
//                                                  ),
//                                                ),
//                                              ),
//                                            ),
                                            Expanded(
                                              flex: 80,
                                              child: Container(
                                                child: Slider(
                                                  value: textSize,
                                                  onChanged: (newRating) {
                                                    setState(() =>
                                                        textSize = newRating);
                                                  },
                                                  onChangeEnd: (newRating) {
                                                    setState(() {
                                                      _menuShown = !_menuShown;
                                                    });
                                                  },
                                                  divisions: 4,
                                                  min: 0,
                                                  max: 40,
                                                ),
                                              ),
                                            ),
//                                            Expanded(
//                                              flex: 10,
//                                              child: GestureDetector(
//                                                onTap: () {
//                                                  setState(() {
//                                                    if (textSize != 40) {
//                                                      textSize++;
//                                                    }
//                                                  });
//                                                },
//                                                child: Container(
//                                                  child: Text("A",
//                                                      style: TextStyle(
//                                                          fontFamily: "Moon",
//                                                          fontSize: 25,
//                                                          fontWeight:
//                                                              FontWeight.w600)),
//                                                ),
//                                              ),
//                                            ),

                                            SizedBox(
                                              width: 30,
                                              child: FlatButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (textSize != 40) {
                                                      textSize++;
                                                    }
                                                  });
                                                },
                                                padding: EdgeInsets.all(0),
                                                child: Text("A",
                                                    style: TextStyle(
                                                        fontFamily: "Moon",
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                          )),
                    )),
                right: 20.0,
                top: -4.0,
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<List<Dua>> getAllDuas(DuaHelper dbHelper) async {
    List<Dua> gDua = [];
    await dbHelper.getAllDua(widget.duaHeading.id).then((value) {
      int i = 0;
      for (Dua dua in value) {
        gDua.add(dua);
        i++;
      }
    });
    int position=0;
    for(Dua data in gDua) {
      if (
      data.duaPartNo == widget.positions) {

        pageController=new PageController(initialPage: position);

this.position=position;
      }
      position++;
    }
//    pageController.animateToPage(widget.position, duration: Duration(milliseconds: 1000), curve: Curves.ease);

    return gDua;
  }

  Future<List<Dua>> updateCount(DuaHelper dbHelper, int id, int count) async {
    await dbHelper.updateCount(id, count);
  }
  Future<List<Dua>> updateLike(DuaHelper dbHelper, int id, String status) async {
    await dbHelper.updateLike(id, status);

  }

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }
}

class _CustomScrollPhysics extends ScrollPhysics {
  _CustomScrollPhysics({
    ScrollPhysics parent,
  }) : super(parent: parent);

  @override
  _CustomScrollPhysics applyTo(ScrollPhysics ancestor) {
    return _CustomScrollPhysics(parent: buildParent(ancestor));
  }
}

//class _ShapedWidget extends StatefulWidget {
//  _ShapedWidget({this.onlyTop = false, this.value});
//  double value;
//  final double padding = 4.0;
//  final bool onlyTop;
//
//  @override
//  Widget build(BuildContext context) {
//    return
//  }
//
//  @override
//  State<StatefulWidget> createState() {
//    // TODO: implement createState
//    return null;
//  }
//}

//class _ShapedWidgetBorder extends RoundedRectangleBorder {
//  _ShapedWidgetBorder({
//    @required this.padding,
//    side = BorderSide.none,
//    borderRadius = BorderRadius.zero,
//  }) : super(side: side, borderRadius: borderRadius);
//  final double padding;
//
//  @override
//  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
//    return Path()
//      ..moveTo(rect.width - 8.0 , rect.top)
//      ..lineTo(rect.width - 20.0, rect.top - 16.0)
//      ..lineTo(rect.width - 32.0, rect.top)
//      ..addRRect(borderRadius
//          .resolve(textDirection)
//          .toRRect(Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height - padding)));
//  }
//}
