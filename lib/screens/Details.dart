import 'dart:ui';

import 'package:adhkaar/audio/Audiowidgte.dart';
import 'package:adhkaar/database/helper/Helper.dart';
import 'package:adhkaar/database/model/Dua.dart';
import 'package:adhkaar/database/model/Duaheading.dart';
import 'package:adhkaar/database/modelhelper/DuaHelper.dart';
import 'package:adhkaar/screens/subdivisionview.dart';
import 'package:adhkaar/utils/colors.dart';
import 'package:adhkaar/utils/numberdart.dart';
import 'package:adhkaar/utils/stagewiget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class DetailPage extends StatefulWidget {
  DetailPage({@required this.duaHeading, Key key}) : super(key: key);

  final DuaHeading duaHeading;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  ScrollController scrollController;
  PageController pageController;
  AnimationController animationBar;
  DuaHelper helper;
  AnimationController scaleAnimation;
  AnimationController animationController;
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

    Duas=getAllDuas(helper);
    position = 0;
    textSize = 12;
    scaleAnimation = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000),
        lowerBound: 0.0,
        upperBound: 1.0);
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
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
            leading: Material(
              color: Colors.transparent,
              type: MaterialType.transparency,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.black,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),

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
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, right: 10.0),
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
                      count=snapshot.data[position].todaysCount;
                      return Column(
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                            child: Center(
                              child: Hero(
                                tag: widget.duaHeading.id.toString() + "_title",
                                child: Text(
                                  widget.duaHeading.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "Kartika",
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: widget.duaHeading.pallet),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                  "/" + snapshot.data.length.toString(),
                                  style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Moon",
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                )
                              ],
                            ),
                          ),
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
                                        Container(
                                          alignment: Alignment.center,
                                          height: 300,
                                          width: 60,
                                          child: RotatedBox(
                                              quarterTurns: 3,
                                              child: DefaultTabController(
                                                child: TabBar(
                                                  tabs: [
                                                    Tab(
                                                      child: Text(
                                                        "Arabic",
                                                        style: TextStyle(
                                                            fontFamily: "Moon",
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: tabPos == 0
                                                                ? lightBlack
                                                                : lightGrey),
                                                      ),
                                                    ),

                                                    Tab(
                                                      child: Text(
                                                        "Transilation",
                                                        style: TextStyle(
                                                            fontFamily: "Moon",
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: tabPos == 2
                                                                ? lightBlack
                                                                : lightGrey),
                                                      ),
                                                    ),
                                                  ],
                                                  indicator: BoxDecoration(
                                                      border: Border(
                                                    top: BorderSide(
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                      width: 5.0,
                                                    ),
                                                  )),
                                                  indicatorPadding:
                                                      EdgeInsets.all(0),
                                                  labelPadding:
                                                      EdgeInsets.only(top: 10),
                                                  onTap: (pos) {
                                                    setState(() {
                                                      tabPos = pos;
                                                    });
                                                  },
                                                ),
                                                length: 2,
                                              )),
                                        ),
                                        Expanded(
                                          child: FutureBuilder<List<Dua>>(
                                              future: Duas,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return PageView.builder(
                                                    itemBuilder:
                                                        (context, position) {
                                                      Dua dua = snapshot
                                                          .data[position];

                                                      return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10.0,
                                                                right: 10.0,
                                                                bottom: 30.0,
                                                                top: 10),
                                                        child: InkWell(
                                                          onTap: () {
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
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .black
                                                                          .withAlpha(
                                                                              70),
                                                                      offset: Offset(
                                                                          3.0,
                                                                          10.0),
                                                                      blurRadius:
                                                                          15.0)
                                                                ]),
                                                            height: 250.0,
                                                            child: Stack(
                                                              children: <
                                                                  Widget>[
                                                                Hero(
                                                                  tag: dua.id
                                                                          .toString() +
                                                                      "_background1",
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                16,
                                                                            bottom:
                                                                                16,
                                                                            left:
                                                                                16,
                                                                            right:
                                                                                5),
                                                                        child:
                                                                            Scrollbar(
                                                                          child:
                                                                              SingleChildScrollView(
                                                                            physics:
                                                                                AlwaysScrollableScrollPhysics(),
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.only(right: 11),
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: <Widget>[
                                                                                  Material(
                                                                                    color: Colors.transparent,
                                                                                    child: tabPos==0?Text(
                                                                                      dua.duaAr,
                                                                                      style: TextStyle(fontSize: textSize),
                                                                                      textDirection: TextDirection.rtl,
                                                                                    ):dua.duaTrans=="no"||dua.duaTrans==""?Text(
                                                                                      dua.duaAr,
                                                                                      style: TextStyle(fontSize: textSize),
                                                                                      textDirection: TextDirection.rtl,
                                                                                    ):Text(
                                                                                      dua.duaTrans,
                                                                                      style: TextStyle(fontSize: textSize,fontStyle: FontStyle.italic),
                                                                                      textDirection: TextDirection.ltr,
                                                                                    ),
                                                                                  ),
                                                                                  Divider(
                                                                                    thickness: 1,
                                                                                  ),
                                                                                  Material(
                                                                                    color: Colors.transparent,
                                                                                    child: Text(
                                                                                      dua.duaTr,
                                                                                      style: TextStyle(
                                                                                        fontSize: textSize,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        wordSpacing: 5,
                                                                                        letterSpacing: .5,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Material(
                                                                                    color: Colors.transparent,
                                                                                    child: Text(
                                                                                      "",
                                                                                      style: TextStyle(fontSize: textSize),
                                                                                      textDirection: TextDirection.rtl,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      children: <
                                                                          Widget>[
                                                                        Expanded(
//                                                            width: MediaQuery.of(
//                                                                        context)
//                                                                    .size
//                                                                    .width -
//                                                                100 -
//                                                                108,
                                                                            child:
                                                                                PlayerWidget(
                                                                          url:
                                                                              "https://halva1.000webhostapp.com/adkarimage/15.mp3",
                                                                          playStatus: snapshot
                                                                              .data[position]
                                                                              .playStatus,
                                                                        )),
                                                                        SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Container(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                88,
                                                                            height:
                                                                                40,
                                                                            child:
                                                                                NeumorphicButton(
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
                                                                          width:
                                                                              10,
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
                                                    onPageChanged: (position) {
                                                      prevposition=this.position;
                                                      this.position = position;

                                                      updateCount(helper,snapshot.data[prevposition].id, count);
                                                      count=snapshot.data[position].todaysCount;
                                                      int i = 0;
                                                      for (Dua todo
                                                          in snapshot.data) {
                                                        if (position != i) {
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

                                                      setState(() {});
                                                    },
                                                    controller: pageController,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    physics:
                                                        _CustomScrollPhysics(),
                                                    pageSnapping: true,
                                                    //  controller: scrollController,

                                                    itemCount:
                                                        snapshot.data.length,
                                                  );
                                                } else {
                                                  return Container(
                                                    alignment: Alignment.center,
                                                    child: SizedBox(
                                                      height: 30,
                                                      width: 30,
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  );
                                                }
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(),
                                        ),
                                        RotationTransition(
                                          turns: new AlwaysStoppedAnimation(
                                              45 / 360),
                                          child: SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: Neumorphic(
                                              boxShape:
                                                  NeumorphicBoxShape.roundRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                              style: NeumorphicStyle(
                                                  shape:
                                                      NeumorphicShape.concave,
                                                  depth: 3,
                                                  intensity: .4,
                                                  lightSource: LightSource.left,
                                                  color: position == 0
                                                      ? Colors.grey
                                                      : whitebg,
                                                  shadowLightColor: whitebg,
                                                  shadowDarkColor:
                                                      Colors.black),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.blueAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  onTap: () {
                                                    pageController
                                                        .animateToPage(
                                                            position == 0
                                                                ? 0
                                                                : position - 1,
                                                            duration: Duration(
                                                                milliseconds:
                                                                    1000),
                                                            curve: Curves.ease);
                                                  },
                                                  child: RotationTransition(
                                                    turns:
                                                        new AlwaysStoppedAnimation(
                                                            -45 / 360),
                                                    child: Icon(
                                                      Icons.navigate_before,
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
                                          turns: new AlwaysStoppedAnimation(
                                              45 / 360),
                                          child: SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: Neumorphic(
                                              boxShape:
                                                  NeumorphicBoxShape.roundRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                              padding: EdgeInsets.all(0),
                                              style: NeumorphicStyle(
                                                  shape:
                                                      NeumorphicShape.concave,
                                                  depth: 3,
                                                  intensity: .5,
                                                  lightSource: LightSource.left,
                                                  color: position ==
                                                          snapshot.data.length - 1
                                                      ? Colors.grey
                                                      : Colors.blue
                                                          .withOpacity(0.8),
                                                  shadowLightColor:
                                                      Colors.white,
                                                  shadowDarkColor:
                                                      Colors.black),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  splashColor: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: RotationTransition(
                                                      turns:
                                                          new AlwaysStoppedAnimation(
                                                              -45 / 360),
                                                      child: Icon(
                                                          Icons.navigate_next,
                                                          size: 20)),
                                                  onTap: () {
                                                    pageController.animateToPage(
                                                        position ==
                                                                snapshot.data.length - 1
                                                            ? position
                                                            : position + 1,
                                                        duration: Duration(
                                                            milliseconds: 1000),
                                                        curve: Curves.ease);
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
                                  )
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
                    }
                    else
                      {
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
    return gDua;
  }

  Future<List<Dua>> updateCount(DuaHelper dbHelper,int id,int count) async {


    await dbHelper.updateCount(id,count);

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
