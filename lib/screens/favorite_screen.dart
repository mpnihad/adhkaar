import 'dart:async';
import 'dart:ui';

import 'package:adhkaar/database/helper/Helper.dart';
import 'package:adhkaar/database/model/Duaheading.dart';
import 'package:adhkaar/database/modelhelper/DuaHeadingHelper.dart';
import 'package:adhkaar/database/modelhelper/DuaHelper.dart';
import 'package:adhkaar/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

import 'Details.dart';

class FavoriteScreen extends StatefulWidget {
  FavoriteScreen({Key key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with TickerProviderStateMixin {
  Timer _timer;

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

  DuaHelper wishlistHelper;

  @override
  void initState() {
    var dbHelper = Helper();
    helper = DuaHeadingHelper(dbHelper.db);
    duaHelper = DuaHeadingHelper(dbHelper.db);
    wishlistHelper = DuaHelper(dbHelper.db);

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
                        child: NestedScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            headerSliverBuilder: (BuildContext context,
                                bool innerBoxIsScrolled) {
                              return <Widget>[
                                ///First sliver is the App Bar
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
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 20),
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Image.asset(
                                                    "assets/images/icon.png",
                                                    width: 50,
                                                    height: 50,
                                                  ),
                                                ),
                                              ),
                                              offset: Offset(-dx,
                                                  -kToolbarHeight - 35 + dx),
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
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 25.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    'SelametLebaran'),
                                                            textAlign: TextAlign
                                                                .center,
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
                                )
                              ];
                            },
                            body: Container(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 20.0,
                                  bottom: 5.0,
                                  right: 20.0,
                                  left: 20.0,
                                ),
                                child: FutureBuilder<List<DuaHeading>>(
                                    future: getFavoriteData(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return CustomScrollView(
                                            physics:
                                                AlwaysScrollableScrollPhysics(),
                                            slivers: <Widget>[
                                              SliverStaggeredGrid.countBuilder(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 20,
                                                mainAxisSpacing: 20,
                                                staggeredTileBuilder: (_) =>
                                                    StaggeredTile.fit(1),
                                                itemBuilder: (context, index) {
                                                  animationController.forward();
                                                  return listItem(
                                                      index,
                                                      Color(0xff1b305d),
                                                      snapshot.data);
                                                },
                                                itemCount: snapshot.data.length,
                                              ),
                                              SliverToBoxAdapter(
                                                  child: Container(
                                                height: 80,
                                              ))
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
                                    }),
                              ),
                            )),
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
    subDuaHeading.pallet = pallete;
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
                          DetailPage(
                        duaHeading: duaHeading,
                        positions: subDuaHeading.partno,
                      ),
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
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              width: 150.0,
              height: 170.0,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color(int.parse(subSection.color)), width: 1),

                borderRadius: BorderRadius.circular(6.0),
//
                color: Color(int.parse(subSection.color)).withOpacity(.08),
              ),
              padding: EdgeInsets.only(top: 20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
//                            Image(
//                              image: AssetImage(pSection.image),
//                              width: 50.0,
//                              color: Color(pSection.color),
//                              height: 50.0,
//                            ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, right: 5, left: 5),
                      child: Text(
                        subSection.name,
                        style: TextStyle(
                            color: pallete,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, right: 5, left: 5),
                      child: Text(
                        subSection.duaAr,
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: pallete,
                          fontSize: 10,
                        ),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, right: 5, left: 5),
                      child: Text(
                        subSection.duaTr,
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: pallete,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(),
                        GestureDetector(
                          onTap: () {
                            updateLike(
                                wishlistHelper, subSection.duaId, "FALSE");
                          },
                          child: Container(
                            padding:
                                const EdgeInsets.only(right: 5.0, bottom: 5),
                            child: Container(
                              padding: EdgeInsets.only(
                                  right: 6, left: 8, top: 8, bottom: 8),
                              decoration: BoxDecoration(
                                color: whitebg,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: LikeButton(
                                size: 15,
                                circleColor: CircleColor(
                                    start: Colors.blue, end: Colors.blue),
                                bubblesColor: BubblesColor(
                                  dotPrimaryColor: Colors.blue,
                                  dotSecondaryColor: Colors.blue,
                                ),
                                likeBuilder: (bool isLiked) {
                                  return isLiked
                                      ? Icon(FontAwesomeIcons.solidBookmark,
                                          color: Colors.blueAccent, size: 15)
                                      : Icon(
                                          FontAwesomeIcons.bookmark,
                                          color: Colors.black,
                                          size: 15,
                                        );
                                },
                                onTap: (isLiked) {
                                  return updateLike(wishlistHelper,
                                      subSection.duaId, "FALSE");
//                        if( isLiked)
//                        {

//                        }
//                        else
//                        {
//                          updateLike(
//                              wishlistHelper,
//                              subSection.id,
//                              "TRUE");
//
//
//                        }
                                },
                                isLiked: true,
                                padding: EdgeInsets.all(0),
                                crossAxisAlignment: CrossAxisAlignment.start,
                                likeCount: null,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 5,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color(int.parse(subSection.color)), width: 1),

                borderRadius: BorderRadius.circular(8.0),
//
                color: Color(int.parse(subSection.color)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  height: 40,
                  width: 40,
                  child: CachedNetworkImage(
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    imageUrl: subSection.image,
                    placeholder: (context, url) => SizedBox(
                        width: 10.0,
                        height: 10.0,
                        child: new CircularProgressIndicator(
                          strokeWidth: 2.0,
                        )),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ),
        ],
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

  Future<bool> updateLike(DuaHelper dbHelper, int id, String status) async {
    print(status + " Likestatus" + " $id");
    Provider.of<DuaHeadingHelper>(
      context,
      listen: false,
    ).updateLikefav(id, status);
//    await dbHelper.updateLikefav(id, status);

    Provider.of<DuaHeadingHelper>(
      context,
      listen: false,
    ).getFavoriteData();
    setState(() {});
//    Dua=getFavoriteData();

    return false;
  }

  Future<List<DuaHeading>> getFavoriteData() async {
    List<DuaHeading> dua =
        await Provider.of<DuaHeadingHelper>(context, listen: true)
            .getFavoriteData();

    return dua;
  }
}
