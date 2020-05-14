import 'dart:async';
import 'dart:ui';

import 'package:adhkaar/database/helper/Helper.dart';
import 'package:adhkaar/database/model/Duaheading.dart';
import 'package:adhkaar/database/model/Section.dart';
import 'package:adhkaar/database/modelhelper/DuaHeadingHelper.dart';
import 'package:adhkaar/database/modelhelper/SectionHelper.dart';
import 'package:adhkaar/model/ListCardModel.dart';
import 'package:adhkaar/utils/colors.dart';
import 'package:adhkaar/utils/expandable.dart';
import 'package:adhkaar/widget/list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:palette_generator/palette_generator.dart';

import 'Details.dart';

class ListArticles extends StatefulWidget {
  ListArticles({
    Key key,
    this.animation,
    this.section,
  }) : super(key: key);
  Section section;
  AnimationController animation;

  @override
  _ListArticlesState createState() => _ListArticlesState();
}

class _ListArticlesState extends State<ListArticles>
    with TickerProviderStateMixin {
  ScrollController _scrollController;
  ScrollController _scrollController1;
  List<PaletteGenerator> pallets;
  List<bool> isExpanded = [];

//  bool animation_liststatus;
//  bool animation_colorstatus;
  Future<List<DuaHeading>> duaHeadinglist;

  int duaHeadingId;
  SectionHelper helper;
  DuaHeadingHelper duaHelper;

  bool lastStatus = true;

  double expandedsize;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
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
    helper = SectionHelper(dbHelper.db);
    duaHelper = DuaHeadingHelper(dbHelper.db);

    pallets = [];
    _colorTween1 = [];

//    palletitem();
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
          _ColorAnimationController1.forward();

          setState(() {});
        }
//          animationController.reverse();
      });

    _ColorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween =
        ColorTween(begin: Colors.transparent, end: Color(widget.section.color))
            .animate(_ColorAnimationController);

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
    widget.animation.duration = Duration(milliseconds: 2000);
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
                    },
                    child: MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: Material(
                        color: Colors.transparent,
                        child: NestedScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            headerSliverBuilder: (BuildContext context,
                                bool innerBoxIsScrolled) {
                              return <Widget>[
                                ///First sliver is the App Bar
                                AnimatedBuilder(
                                    animation: _ColorAnimationController,
                                    builder: (context, snapshot) {
                                      return SliverAppBar(
                                        ///Properties of app bar
                                        ///

//                                    backgroundColor: isShrink
//                                        ? Color(widget.prevColor)
//                                        : _colorTween.value,
                                        backgroundColor: whitebg,
                                        floating: false,
                                        snap: false,
                                        pinned: true,
                                        leading: IconButton(
                                          icon: Icon(Icons.arrow_back,
                                              color: Colors.black),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            widget.animation.duration =
                                                Duration(milliseconds: 2000);
                                          },
                                        ),
                                        expandedHeight: expandedsize,

                                        ///Properties of the App Bar when it is expanded
                                        flexibleSpace: Stack(
                                          children: <Widget>[
                                            FlexibleSpaceBar(
                                              centerTitle: true,
                                              titlePadding:
                                                  const EdgeInsets.only(
                                                      right: 60.0, left: 60.0),
                                              collapseMode: CollapseMode.pin,
                                              title: LayoutBuilder(builder:
                                                  (BuildContext context,
                                                      BoxConstraints
                                                          constraints) {
                                                double percent =
                                                    ((constraints.maxHeight -
                                                            kToolbarHeight) *
                                                        100 /
                                                        (expandedsize));
                                                double per = percent == 100
                                                    ? 1
                                                    : (100 - percent);
                                                double padding = 100 -
                                                    (100 -
                                                        ((100 * percent) /
                                                            100));
                                                double padding2 = 10 -
                                                    (10 -
                                                        ((10 * percent) / 100));
                                                return Container(
                                                  padding: EdgeInsets.only(
                                                      top: padding),
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: SizedBox(
                                                    height: (expandedsize / 2),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Text(
                                                          "Adkhar",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  'SelametLebaran'),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top:
                                                                      padding2),
                                                          child: Text(
                                                            widget.section.name,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Butler",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: isShrink
                                                                    ? Colors
                                                                        .black
                                                                    : Color(widget
                                                                        .section
                                                                        .color)),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ),
                                            Positioned(
                                              right: 10,
                                              top: 10,
                                              child: Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                padding:
                                                    EdgeInsets.only(right: 10),
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
                                                        backgroundColor:
                                                            Colors.black,
                                                        backgroundImage:
                                                            AssetImage(
                                                                "assets/user.png"),
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
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                              border: Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .white)),
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                darkGreens,
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
                                          ],
                                        ),
                                      );
                                    }),
                              ];
                            },
                            body: Container(
                                decoration: new BoxDecoration(),
                                child: FutureBuilder<List<Section>>(
                                    future: getSectionSub(helper),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return CustomScrollView(
                                            physics:
                                                AlwaysScrollableScrollPhysics(),
                                            slivers: <Widget>[
                                              SliverList(
                                                delegate:
                                                    SliverChildBuilderDelegate(
                                                        (BuildContext context,
                                                            int index) {
                                                  return AnimatedBuilder(
                                                      animation: ColorTween(
                                                              begin:
                                                                  Colors.white,
                                                              end: Color(
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .color))
                                                          .animate(
                                                              _ColorAnimationController1),
                                                      builder:
                                                          (BuildContext context,
                                                              Widget child) {
                                                        return listItem(
                                                            index,
                                                            Color(snapshot
                                                                .data[index]
                                                                .color),
                                                            snapshot.data);
                                                      });
                                                },
                                                        childCount: snapshot
                                                            .data.length),
                                              ),
                                            ]);
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
                                    }))),
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

  Widget listItem(int index, Color pallete, List<Section> data) {
    Section subSection = data[index];
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, snapshot) {
          return FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: animationController,
                    curve: Interval((1 / data.length) * index, 1.0,
                        curve: Curves.fastOutSlowIn))),
            child: new Transform(
              transform: index % 2 == 0
                  ? new Matrix4.translationValues(
                      -30 *
                          (1.0 -
                              Tween<double>(begin: 0.0, end: 1.0)
                                  .animate(CurvedAnimation(
                                      parent: animationController,
                                      curve: Interval(
                                          (1 / data.length) * index, 1.0,
                                          curve: Curves.fastOutSlowIn)))
                                  .value),
                      0.0,
                      0.0)
                  : new Matrix4.translationValues(
                      30 *
                          (1.0 -
                              Tween<double>(begin: 0.0, end: 1.0)
                                  .animate(CurvedAnimation(
                                      parent: animationController,
                                      curve: Interval(
                                          (1 / data.length) * index, 1.0,
                                          curve: Curves.fastOutSlowIn)))
                                  .value),
                      0.0,
                      0.0),
              child:

              GestureDetector(
                onTap: () {
                  setState(() {
//                    Timer(Duration(milliseconds: 300), () {
//                      _scrollController.animateTo(((index + 1) * 125.0),
//                          duration: Duration(seconds: 1), curve: Curves.ease);
//                    });

                    duaHeadingId = subSection.id;
                    duaHeadinglist =
                        getDuaHeading(duaHelper, subSection.id, pallete);
                    int i = 0;
                    for (bool status in isExpanded) {
                      if (i != index) {
                        isExpanded[i] = false;
                      }
                      i++;
                    }
                    isExpanded[index] = !isExpanded[index];
                    print(((index + 1) * 125.0));
                  });

//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => SubDivitionPage(
//                              list: listcardmodel[index],
//                              prevcolor: widget.prevColor)));
                },
                child:
                AnimatedContainer(
                  curve: Curves.bounceOut,
                  child:   ExpandableCardContainer(
                    expandedChild: createCollapsedColumn(
                        context, index, pallete, subSection),
                    collapsedChild:
                    createExpandedColumn(context, index, pallete, subSection),
                    isExpanded: isExpanded[index],
                  ),
                  duration: Duration(milliseconds: 200),
                )

              ),
            ),
          );
        });
  }

  Future<bool> palletitem() async {
    List<PaletteGenerator> palettes = [];
    List<Section> subSections = await getSectionSub(helper);
    int i = 0;
    for (Section subSection in subSections) {
      PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
        NetworkImage(subSection.image),
        size: Size(50, 50),
      );
      pallets.add(paletteGenerator);
      _colorTween1.insert(
          i,
          ColorTween(
                  begin: Colors.white,
                  end: paletteGenerator.dominantColor.color)
              .animate(_ColorAnimationController1));

      print(" Section id : ${subSection.id}  :" +
          paletteGenerator.dominantColor.color.toString());
      i++;
    }

    return true;
  }

  createExpandedColumn(
      BuildContext context, int index, Color pallete, Section subSection) {
    return Container(
      padding: index == 0 ? EdgeInsets.only(top: 8) : EdgeInsets.only(top: 0),
      child: ListCard(
        image: subSection.image,
        title: subSection.name,
        date: "",
        inverted: index % 2 == 0 ? false : true,
        prevColor: Color(widget.section.color),
        palletcolor: pallete,
      ),
    );
  }

  createCollapsedColumn(
      BuildContext context, int index, Color pallete, Section subSection) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: <Widget>[
          Container(
            height: 125,
            padding:
                index == 0 ? EdgeInsets.only(top: 8) : EdgeInsets.only(top: 0),
            child: ListCard(
              image: subSection.image,
              title: subSection.name,
              date: "",
              inverted: index % 2 == 0 ? false : true,
              prevColor: Color(widget.section.color),
              palletcolor: pallete,
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Material(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                color: Colors.transparent,
                elevation: 0.0,
                child: Neumorphic(
                  boxShape: NeumorphicBoxShape.roundRect(
                      borderRadius: BorderRadius.circular(6)),
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      depth: -8,
                      intensity: 0,
                      lightSource: LightSource.topLeft,
                      color: whitebg,
                      shadowDarkColorEmboss: whitebg),
                  child: FutureBuilder<List<DuaHeading>>(
                      future: duaHeadinglist,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return CustomScrollView(
//            physics: _CustomScrollPhysics(),
//            controller: scrollController,
                            physics: AlwaysScrollableScrollPhysics(),
//            controller: scrollController,

                            slivers: [
                              SliverPadding(
                                padding: const EdgeInsets.only(
                                    top: 5, right: 0, left: 0, bottom: 0),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      return listdown(index, snapshot.data);
                                    },
                                    childCount: snapshot.data.length,
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget listdown(int index, List<DuaHeading> data) {
    DuaHeading dataHeading = data[index];

    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
      child: Padding(
        padding: EdgeInsets.only(right: 0),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.transparent,
            ),
            child: InkWell(
              splashColor: blueGrey,
              borderRadius: BorderRadius.circular(6.0),
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) =>
                        DetailPage(duaHeading: dataHeading),
                    transitionDuration: Duration(milliseconds: 1000),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Container(
                          alignment: Alignment.center,
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
                              ]),
                          child: Center(
                              child: Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              color: dataHeading.pallet,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(0.2, 0.2),
                                    blurRadius: 1.0,
                                    color: Colors.black54,
                                  ),

                                ]
                            ),

                          )),
                        ),
                      ),
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: EdgeInsets.only(left: 15),
                            child: Hero(
                              tag: dataHeading.id.toString() + "_title",
                              child: Text(
                                dataHeading.name,
                                style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w600),
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
          ),
        ),
      ),
    );
  }

  Future<List<Section>> getSectionSub(SectionHelper dbHelper) async {
    List<Section> gSection = [];
    await dbHelper.getAllSubSections(widget.section.id).then((value) {
      int i = 0;
      for (Section section in value) {
//        _colorTween1.insert(
//            i,
//            ColorTween(begin: Colors.transparent, end: whitebg)
//                .animate(_ColorAnimationController1));
        isExpanded.add(false);
        gSection.add(section);
        i++;
      }
    });
    return gSection;
  }

  Future<List<DuaHeading>> getDuaHeading(
      DuaHeadingHelper dbHelper, int id, Color pallete) async {
    List<DuaHeading> gDuaHeading = [];
    await dbHelper.getAllDuaHeading(id).then((value) {
      int i = 0;
      for (DuaHeading duaHeading in value) {
        duaHeading.pallet = pallete;
        gDuaHeading.add(duaHeading);
        i++;
      }
    });
    return gDuaHeading;
  }
}
