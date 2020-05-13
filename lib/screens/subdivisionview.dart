import 'package:adhkaar/database/model/Duaheading.dart';
import 'package:adhkaar/model/ColorChoice.dart';
import 'package:adhkaar/model/ListCardModel.dart';
import 'package:adhkaar/model/TodoObject.dart';
import 'package:adhkaar/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'Details.dart';

List<TodoObject> todos = [
  TodoObject.import(
      "SOME_RANDOM_UUID",
      "പുതുവസ്ത്രം ധരിച്ചവന് വേണ്ടിയുള്ള പ്രാര്‍ത്ഥന",
      1,
      ColorChoices.choices[0],
      Icons.alarm, {
    DateTime(2018, 5, 3): [
      TaskObject("Meet Clients", DateTime(2018, 5, 3)),
      TaskObject("Design Sprint", DateTime(2018, 5, 3)),
      TaskObject("Icon Set Design for Mobile", DateTime(2018, 5, 3)),
      TaskObject("HTML/CSS Study", DateTime(2018, 5, 3)),
    ],
    DateTime(2019, 5, 4): [
      TaskObject("Meet Clients", DateTime(2019, 5, 4)),
      TaskObject("Design Sprint", DateTime(2019, 5, 4)),
      TaskObject("Icon Set Design for Mobile", DateTime(2019, 5, 4)),
      TaskObject("HTML/CSS Study", DateTime(2019, 5, 4)),
    ]

  },33
  ),
  TodoObject("വസ്ത്രം അഴിക്കുമ്പോഴുള്ള പ്രാര്‍ത്ഥന", Icons.person,10),
  TodoObject("വസ്ത്രം ധരിക്കുമ്പോഴുള്ള പ്രാര്‍ത്ഥന", Icons.work,10),
  TodoObject("പുതുവസ്ത്രം ധരിക്കുമ്പോഴുള്ള പ്രാര്‍ത്ഥന", Icons.home,3),
  TodoObject(
      "സലാം (‘അല്ലാഹു നിങ്ങളുടെ മേല്‍ അനുഗ്രഹവും രക്ഷയും ചൊരിയട്ടെ!’ എന്ന പ്രാര്‍ത്ഥന, ഇസ്‌ലാമിക അഭിവാദ്യം) അധികരിപ്പിക്കുന്നതിന്‍റെ ഗുണങ്ങള്‍", Icons.shopping_basket,33),
//  TodoObject("School", Icons.school),
];

class SubDivitionPage extends StatefulWidget {
  SubDivitionPage({Key key, this.list,this.prevcolor}) : super(key: key);
  ListCardModel list;
  int prevcolor;
  @override
  _SubDivitionPageState createState() => _SubDivitionPageState();
}

class _SubDivitionPageState extends State<SubDivitionPage>
    with TickerProviderStateMixin {
  ScrollController scrollController;
  Color backgroundColor;
  LinearGradient backgroundGradient;
  Tween<Color> colorTween;
  int currentPage = 0;

  Color constBackColor;

  @override
  void initState() {
    super.initState();
    colorTween = ColorTween(begin: todos[0].color, end: todos[0].color);
    backgroundColor = todos[0].color;
    backgroundGradient = todos[0].gradient;
    scrollController = ScrollController();
    scrollController.addListener(() {
      ScrollPosition position = scrollController.position;
//      ScrollDirection direction = position.userScrollDirection;
      int page = position.pixels ~/
          (position.maxScrollExtent / (todos.length.toDouble() - 1));
      double pageDo = (position.pixels /
          (position.maxScrollExtent / (todos.length.toDouble() - 1)));
      double percent = pageDo - page;
      if (todos.length - 1 < page + 1) {
        return;
      }
      colorTween.begin = todos[page].color;
      colorTween.end = todos[page + 1].color;
      setState(() {
        backgroundColor = colorTween.transform(percent);
        backgroundGradient =
            todos[page].gradient.lerpTo(todos[page + 1].gradient, percent);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        whitebg,
        whitebg,
      ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: NestedScrollView(
            physics: AlwaysScrollableScrollPhysics(),
//              controller: scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  centerTitle: false,
//                    title:   Container(
//
//                    alignment: Alignment.centerLeft,
//                    child: Image.asset(
//                    "assets/images/icon.png",
//                    width: 50,
//                    height: 50,
//                    ),
//                    ),

                  ///Properties of app bar
//                  backgroundColor: isShrink
//                      ? Color(widget.prevColor)
//                      : Colors.transparent,
                  floating: true,
                  pinned: true,
                  backgroundColor: whitebg,
                  expandedHeight: 180,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();

                    },
                  ),
                  actions: <Widget>[
                    Container(
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
                              backgroundImage: AssetImage("assets/user.png"),
                              maxRadius: 16,
                            ),
                          ),
                          Positioned(
                            left: -5,
                            bottom: -5,
                            child: GestureDetector(
                              onTap: () {
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) => SettingsScreen()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        width: 1, color: Colors.white)),
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
//                      LayoutBuilder(
//                        builder:
//                            (BuildContext context, BoxConstraints constraints) {
//                          double percent =
//                              ((constraints.maxHeight - kToolbarHeight) *
//                                  100 /
//                                  (180 - kToolbarHeight));
//                          double dx = 0;
//
//                          dx = 100 - percent;
//                          if (constraints.maxHeight == 180) {
//                            dx = 0;
//                          }
//
//                          return Padding(
//                            padding: const EdgeInsets.only(
//                              top: kToolbarHeight / 10,
//                            ),
//                            child: Transform.translate(
//                              child: Container(
//                                alignment: Alignment.bottomCenter,
//                                child: Container(
//                                  padding: EdgeInsets.only(bottom: 20),
//                                  alignment: Alignment.bottomCenter,
//                                  child: Image.asset(
//                                    "assets/images/icon.png",
//                                    width: 50,
//                                    height: 50,
//                                  ),
//                                ),
//                              ),
//                              offset: Offset(-dx, -kToolbarHeight - 35 + dx),
//                            ),
//                          );
//                        },
//                      ),
                      FlexibleSpaceBar(
                        centerTitle: true,
                        titlePadding:
                            const EdgeInsets.only(right: 60.0, left: 60.0),
                        collapseMode: CollapseMode.parallax,
                        title: Stack(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                height: 90.0,
                                child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Column(
                                      children: <Widget>[
                                        Center(
                                          child: Text(
                                            "Adkhar",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 25.0,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'SelametLebaran'),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              widget.list.title,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: "Butler",
                                                  fontSize: 14,
                                                  color: Color(widget.prevcolor),
                                                  fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            ),

//                          LayoutBuilder(
//                            builder: (BuildContext context,
//                                BoxConstraints constraints) {
//                              double percent =
//                              ((constraints.maxHeight - kToolbarHeight) *
//                                  50 /
//                                  (110 - kToolbarHeight));
//                              double dx = 0;
//
//                              dx = 100 - percent;
//                              if (constraints.maxHeight == 100) {
//                                dx = MediaQuery.of(context).size.width/2;
//                              }
//
//                              return Stack(
//                                children: <Widget>[
//                                  Padding(
//                                    padding: const EdgeInsets.only(
//                                        top: kToolbarHeight / 4, left: 20.0,right: 20.0),
//                                    child: Transform.translate(
//                                      child: Container(
//                                        alignment: Alignment.bottomCenter,
//                                        child: Container(
//                                          padding: EdgeInsets.only(bottom: 20),
//                                          alignment: Alignment.bottomCenter,
//                                          child: Image.asset(
//                                            "assets/images/icon.png",
//                                            width: 50,
//                                            height: 50,
//                                          ),
//                                        ),
//                                      ),
//                                      offset: Offset(
//                                          dx,
//                                          constraints.maxHeight -
//                                              kToolbarHeight),
//                                    ),
//                                  ),
//                                ],
//                              );
//                            },
//                          ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: CustomScrollView(
//            physics: _CustomScrollPhysics(),
//            controller: scrollController,
              physics: AlwaysScrollableScrollPhysics(),
//            controller: scrollController,

              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(top: 20,right: 0,left: 0,bottom: 0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return listview(index);
                      },
                      childCount: todos.length,
                    ),
                  ),
                ),
//              Expanded(
//                child: ListView.builder(
//                  itemBuilder: (context, index) {
//                   return listview(index);
//                  },
//                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
//                  scrollDirection: Axis.vertical,
//                  physics: _CustomScrollPhysics(),
//                  controller: scrollController,
//                  itemExtent: 170,
//                  itemCount: todos.length,
//                ),
//              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listview(int index) {
    TodoObject todoObject = todos[index];
    double percentComplete = todoObject.percentComplete();

    return SizedBox(
      height: 140,
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 30.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                        Animation<double> secondaryAnimation) =>
                    DetailPage(duaHeading: new DuaHeading()),
                transitionDuration: Duration(milliseconds: 1000),
              ),
            );
          },
          child: SizedBox(
            height: 120.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 0),
                    child:Neumorphic(
                      boxShape: NeumorphicBoxShape.roundRect(borderRadius: BorderRadius.circular(10)),
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          depth: 8,
                          intensity: .4,

                          lightSource: LightSource.bottomRight,
                          color:whitebg,
                        shadowLightColor: todoObject.color
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.transparent,
//                          boxShadow: [
////                            BoxShadow(
////                                color: Colors.black.withAlpha(70),
////                                offset: Offset(3.0, 10.0),
////                                blurRadius: 15.0)
//
////                            BoxShadow(
////                              color: Colors.white.withOpacity(0.7),
////                              offset: Offset(-6.0, -6.0),
////                              blurRadius: 16.0,
////                            ),
////                            BoxShadow(
////                              color: Colors.black.withOpacity(0.16),
////                              offset: Offset(6.0, 6.0),
////                              blurRadius: 16.0,
////                            ),
//
////                            BoxShadow(
////                                color:todoObject.color.withOpacity(0.15),
////                                offset: Offset(10.0, 10.0),
////                                blurRadius: 10.0,
////                                spreadRadius: 2.0),
////                            BoxShadow(
////                                color:  whitebg,
////                                offset: Offset(-10.0, -10.0),
////                                blurRadius: 10.0,
////                                spreadRadius: 2.0)
//                          ]

                        ),
                        height: 120.0,
                        child: Stack(
                          children: <Widget>[
                            Hero(
                              tag: todoObject.uuid + "_background2",
                              child: Container(
                                decoration: BoxDecoration(

//                                border: Border.all(
//                                    color: todoObject.color,
//                                    width: 2),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
//                                          Hero(
//                                            tag: todoObject.uuid + "_more_vert",
//                                            child: Material(
//                                              color: Colors.transparent,
//                                              type: MaterialType.transparency,
//                                              child: PopupMenuButton(
//                                                icon: Icon(
//                                                  Icons.more_vert,
//                                                  color: Colors.grey,
//                                                ),
//                                                itemBuilder: (context) => <PopupMenuEntry<TodoCardSettings>>[
//                                                  PopupMenuItem(
//                                                    child: Text("Edit Color"),
//                                                    value: TodoCardSettings.edit_color,
//                                                  ),
//                                                  PopupMenuItem(
//                                                    child: Text("Delete"),
//                                                    value: TodoCardSettings.delete,
//                                                  ),
//                                                ],
//                                                onSelected: (setting) {
//                                                  switch (setting) {
//                                                    case TodoCardSettings.edit_color:
//                                                      print("edit color clicked");
//                                                      break;
//                                                    case TodoCardSettings.delete:
//                                                      print("delete clicked");
//                                                      setState(() {
//                                                        todos.remove(todoObject);
//                                                      });
//                                                      break;
//                                                  }
//                                                },
//                                              ),
//                                            ),
//                                          ),
                                        SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: Hero(
                                            tag: todoObject.uuid + "_number2",
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: whitebg,
                                                  borderRadius: BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.white.withOpacity(0.7),
                                                      offset: Offset(-6.0, -6.0),
                                                      blurRadius: 16.0,
                                                    ),
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.16),
                                                      offset: Offset(6.0, 6.0),
                                                      blurRadius: 16.0,
                                                    ),
                                                  ]
                                              ),
                                              child: Center(
                                                  child: Text(
                                                    (index + 1).toString(),
                                                    style: TextStyle(color: todoObject.color),
                                                  )),
                                            ),
                                          ),
                                        ),


                                        Spacer(),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            SizedBox(

                                              width: 100,
                                              child: Hero(
                                                tag:
                                                    todoObject.uuid + "_progress_bar2",
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: Row(
                                                    children: <Widget>[
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(8),
                                                        child: SizedBox(
                                                          width: 65,
                                                          child:
                                                              LinearProgressIndicator(
                                                            value: percentComplete,
                                                            backgroundColor: Colors
                                                                .grey
                                                                .withAlpha(50),
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    todoObject.color),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 30,
                                                        child: Align(
                                                          alignment:
                                                              Alignment.centerRight,
                                                          child: Padding(
                                                            padding: EdgeInsets.only(
                                                                left: 2.0),
                                                            child: Text(
                                                              (percentComplete * 100)
                                                                      .round()
                                                                      .toString() +
                                                                  "%",
                                                              style: TextStyle(
                                                                  fontSize: 10),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right:5.0),
                                              child: Hero(
                                                tag: todoObject.uuid +
                                                    "_number_of_tasks2",
                                                child: Material(
                                                    color: Colors.transparent,
                                                    child: Container(
                                                      padding: EdgeInsets.only(top: 10),
                                                      child: Text(
                                                        todoObject
                                                            .taskAmount()
                                                            .toString() +
                                                            " Duas",
                                                        style: TextStyle(fontSize: 11),
                                                        softWrap: false,
                                                      ),
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),

//                              Hero(
//                                tag: todoObject.uuid +
//                                    "_icon",
//                                child: Container(
//                                  alignment:
//                                  Alignment.topLeft,
//                                  decoration: BoxDecoration(
//                                    color:
//                                    Colors.transparent,
//                                    shape: BoxShape.circle,
////                                                border: Border.all(color: Colors.grey.withAlpha(70), style: BorderStyle.solid, width: 1.0),
//                                  ),
//                                  child: Padding(
//                                    padding:
//                                    EdgeInsets.all(8.0),
//                                    child: LikeButton(
//                                      size: 20,
//                                      circleColor: CircleColor(
//                                          start: todoObject
//                                              .colors[0],
//                                          end: todoObject
//                                              .colors[1]),
//                                      bubblesColor:
//                                      BubblesColor(
//                                        dotPrimaryColor:
//                                        todoObject
//                                            .colors[0],
//                                        dotSecondaryColor:
//                                        todoObject
//                                            .colors[1],
//                                      ),
//                                      likeBuilder:
//                                          (bool isLiked) {
//                                        return isLiked
//                                            ? Icon(
//                                          CupertinoIcons
//                                              .heart_solid,
//                                          color: todoObject
//                                              .color,
//                                          size: 20,
//                                        )
//                                            : Icon(
//                                          CupertinoIcons
//                                              .heart,
//                                          color: todoObject
//                                              .color,
//                                          size: 20,
//                                        );
//                                      },
//                                      padding:
//                                      EdgeInsets.all(0),
//                                      crossAxisAlignment:
//                                      CrossAxisAlignment
//                                          .start,
//                                      likeCount: null,
//                                    ),
////                                                    Icon(todoObject.icon, color: Colors.white),
//                                  ),
//                                ),
//                              ),
                                      ],
                                    ),
                                  ),

                                  Hero(
                                    tag: todoObject.uuid + "_title2",
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        todoObject.title,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
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

  double _getPage(ScrollPosition position) {
    return position.pixels /
        (position.maxScrollExtent / (todos.length.toDouble() - 1));
    // return position.pixels / position.viewportDimension;
  }

  double _getPixels(ScrollPosition position, double page) {
    // return page * position.viewportDimension;
    return page * (position.maxScrollExtent / (todos.length.toDouble() - 1));
  }

  double _getTargetPixels(
      ScrollPosition position, Tolerance tolerance, double velocity) {
    double page = _getPage(position);
    if (velocity < -tolerance.velocity)
      page -= 0.5;
    else if (velocity > tolerance.velocity) page += 0.5;
    return _getPixels(position, page.roundToDouble());
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent))
      return super.createBallisticSimulation(position, velocity);
    final Tolerance tolerance = this.tolerance;
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels)
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    return null;
  }
}
