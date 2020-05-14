import 'dart:async';

import 'dart:ui';

import 'package:adhkaar/database/helper/Helper.dart';
import 'package:adhkaar/database/model/Duaheading.dart';
import 'package:adhkaar/database/model/Section.dart';
import 'package:adhkaar/database/modelhelper/DuaHeadingHelper.dart';
import 'package:adhkaar/utils/colors.dart';
import 'package:adhkaar/widget/list_card.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'dart:math'as math;
import 'Details.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
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

  int singleDataId;
  DuaHeadingHelper helper;
  DuaHeadingHelper duaHelper;
  bool isVisibleSearch = false;
  String query = "";
  bool lastStatus = true;

  double expandedsize;

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

    _focus = FocusNode();
    _focus.addListener(_onFocusChange);

    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(
      Duration(milliseconds: 500),
      () {
        setState(() {
          query = textController.text;
        });
        Provider.of<DuaHeadingHelper>(
          context,
          listen: false,
        ).searchProducts(query: textController.text);
      },
    );

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
                        child:  Column(
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
                                                  BorderRadius.circular(100),
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
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                  ),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 20),
                                      alignment: Alignment.bottomCenter,
                                      child: Image.asset(
                                        "assets/images/icon.png",
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                  ),
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
                              padding: const EdgeInsets.only(bottom:20.0),
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
                                      minHeight:isShrink?110.0:70,

                                      maxHeight: isShrink?110.0:70.0,

                                      child: Container(
                                        color:whitebg,
                                        padding: const EdgeInsets.only(top:8.0,bottom: 16.0,right: 8.0,left: 8.0),
                                        child: Container(

                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),

                                          alignment: Alignment.bottomCenter,

                                          child: SizedBox(
                                            height: 50,
                                            child: Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[



                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: TypeAheadFormField(
                                                    textFieldConfiguration:
                                                    TextFieldConfiguration(
                                                      decoration: InputDecoration(
                                                        fillColor:Colors.black,
                                                        hintText: "Search in Malayalam",
                                                        enabledBorder: InputBorder.none,
                                                        border: InputBorder.none,
                                                      ),
                                                      controller: textController,
                                                      focusNode: _focus,
                                                    ),
                                                    suggestionsCallback:
                                                        (String pattern) {
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

                                                      if (suggestion !=
                                                          textController.text) {
                                                        setState(() {
                                                          textController.text =
                                                              suggestion;
                                                        });
                                                        setState(() {
                                                          query = textController.text;
                                                        });
                                                        Provider.of<DuaHeadingHelper>(
                                                          context,
                                                          listen: false,
                                                        ).searchProducts(
                                                            query: textController.text);
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
                                                  width: widthButtonCancel==0?50:0,
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
                                                      onPressed: () {

                                                      },
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
//                                SliverFixedExtentList(
//                                    itemExtent: 150.0,
//                                    delegate: SliverChildListDelegate([
//
//                                    ])),
                                  FutureBuilder<List<DuaHeading>>(
                                      future: getSearchData(name: query),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return SliverList(
                                            delegate:
                                            SliverChildBuilderDelegate(
                                                    (BuildContext context,
                                                    int index) {
                                                  return AnimatedBuilder(
                                                      animation: ColorTween(
                                                          begin: Colors.white,
                                                          end:
                                                          Color(0xff1b305d))
                                                          .animate(
                                                          _ColorAnimationController1),
                                                      builder:
                                                          (BuildContext context,
                                                          Widget child) {
                                                        return listItem(
                                                            index,
                                                            Color(0xff1b305d),
                                                            snapshot.data);
                                                      });
                                                },
                                                childCount:
                                                snapshot.data.length),
                                          );
                                        } else {
                                          return SliverToBoxAdapter(
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: SizedBox(
                                                height: 30,
                                                width: 30,
                                                child:
                                                CircularProgressIndicator(),
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

  Widget listItem(int index, Color pallete, List<DuaHeading> data) {
    DuaHeading subDuaHeading = data[index];
    subDuaHeading.pallet=pallete;
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
              child: GestureDetector(
                onTap: () {
                  DuaHeading duaHeading = new DuaHeading.forSearch(
                      subDuaHeading.id,
                      subDuaHeading.name,
                      subDuaHeading.pallet);
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) =>
                          DetailPage(duaHeading: duaHeading),
                      transitionDuration: Duration(milliseconds: 1000),
                    ),
                  );
                  setState(() {
//                    Timer(Duration(milliseconds: 300), () {
//                      _scrollController.animateTo(((index + 1) * 125.0),
//                          duration: Duration(seconds: 1), curve: Curves.ease);
//                    });

//                    singleDataId=subSection.id;
//                    singleDatalist=getSingleData(duaHelper,subSection.id,pallete);
//                    int i = 0;
//                    for (bool status in isExpanded) {
//                      if (i != index) {
//                        isExpanded[i] = false;
//                      }
//                      i++;
//                    }
//                    isExpanded[index] = !isExpanded[index];
//                    print(((index + 1) * 125.0));
                  });

//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => SubDivitionPage(
//                              list: listcardmodel[index],
//                              prevcolor: widget.prevColor)));
                },
                child: createExpandedColumn(
                    context, index, pallete, subDuaHeading),
              ),
            ),
          );
        });
  }

  createExpandedColumn(
      BuildContext context, int index, Color pallete, DuaHeading subSection) {
    return Container(
      padding: index == 0 ? EdgeInsets.only(top: 8) : EdgeInsets.only(top: 0),
      child: ListCard(
        image:
            "https://res.cloudinary.com/halva/image/upload/v1588908206/adkhar/20190504_ryuaxg.jpg",
        title: subSection.name,
        date: "",
        inverted: index % 2 == 0 ? false : true,
        prevColor: Colors.white,
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
              prevColor: Colors.white,
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
                      future: singleDatalist,
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
    DuaHeading singleDataHeading = data[index];

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
                DuaHeading duaHeading = new DuaHeading.forSearch(
                    singleDataHeading.id,
                    singleDataHeading.name,
                    singleDataHeading.pallet);
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) =>
                        DetailPage(duaHeading: duaHeading),
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
                              color: singleDataHeading.pallet,
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
                              tag: singleDataHeading.id.toString() + "_title",
                              child: Text(
                                singleDataHeading.name,
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

//
//  Future<List<DuaHeading>> getSearchData(
//      DuaHeadingHelper dbHelper, String query) async {
//    List<DuaHeading> gDuaHeading = [];
//    await dbHelper.getDuaHeadings(query).then((value) {
//      int i = 0;
//      for (DuaHeading singleData in value) {
//        gDuaHeading.add(singleData);
//        i++;
//      }
//    });
//    return gDuaHeading;
//  }

  Future<List<DuaHeading>> getSearchData({name}) async {
    List<DuaHeading> dua =
        await Provider.of<DuaHeadingHelper>(context, listen: true)
            .searchProducts(
      query: name,
    );
    return dua;
  }

  Widget _transitionBuilder(BuildContext context, Widget suggestionsBox,
      AnimationController controller) {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(
      Duration(milliseconds: 500),
      () {
        setState(() {
          query = textController.text;
        });
        Provider.of<DuaHeadingHelper>(
          context,
          listen: false,
        ).searchProducts(query: textController.text);
      },
    );
    return suggestionsBox;
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
    return new SizedBox.expand(

        child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
//    return maxHeight != oldDelegate.maxHeight ||
//        minHeight != oldDelegate.minHeight ||
//        child != oldDelegate.child;
  }
}