import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:adhkaar/database/helper/Helper.dart';
import 'package:adhkaar/database/model/Section.dart';
import 'package:adhkaar/database/modelhelper/SectionHelper.dart';
import 'package:adhkaar/screens/list_articles.dart';
import 'package:adhkaar/screens/singledatalist.dart';
import 'package:adhkaar/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';



class BrowseScreen extends StatefulWidget {
  const BrowseScreen({Key key}) : super(key: key);

  @override
  _BrowseScreenState createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen>
    with SingleTickerProviderStateMixin, TickerProviderStateMixin {
  TabController controller;
  AnimationController animationController;
  AnimationController controllers;
  SectionHelper helper;
  Future<List<Section>> sections;

  ScrollController _scrollControllerbro;
  int _currentPage;
  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollControllerbro.hasClients &&
        _scrollControllerbro.offset > (200 - kToolbarHeight);
  }

  final Shader linearGradient = LinearGradient(
    colors: <Color>[primaryColor1, secondaryColorGreen],
  ).createShader(new Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  static getRandomColor() =>
      Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
          .withOpacity(1.0);

  @override
  void initState() {
    var dbHelper = Helper();
    helper = SectionHelper(dbHelper.db);

    _currentPage = 0;
    _scrollControllerbro = ScrollController();
    _scrollControllerbro.addListener(_scrollListener);
    super.initState();
    controller = TabController(vsync: this, length: 3);
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    controllers = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    _scrollControllerbro.dispose();
    _scrollControllerbro.removeListener(_scrollListener);
    super.dispose();
  }

  getPage(int page) {
    switch (page) {
      case 0:
        return Center(
            child: Container(
              child: Text("Home Page"),
            ));
      case 1:
        return Center(
            child: Container(
              child: Text("Profile Page"),
            ));
      case 2:
        return Center(
            child: Container(
              child: Text("Cart Page"),
            ));
    }
  }


  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return Scaffold(
//
      body: Stack(
        children: <Widget>[
          Container(
//        decoration: BoxDecoration(
//          image: DecorationImage(
//            image: AssetImage("assets/images/background.jpeg"),
//            fit: BoxFit.cover,
////            colorFilter: ColorFilter.mode(Colors.white,BlendMode.multiply),
//          ),
//        ),

            color: whitebg,
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
                child: NestedScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: _scrollControllerbro,
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
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
                          ],

                          ///Properties of the App Bar when it is expanded
                          flexibleSpace: Stack(
                            children: <Widget>[
                              LayoutBuilder(
                                builder: (BuildContext context,
                                    BoxConstraints constraints) {
                                  double percent = ((constraints.maxHeight -
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
                                          padding: EdgeInsets.only(bottom: 20),
                                          alignment: Alignment.bottomCenter,
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
                                            alignment: Alignment.bottomLeft,
                                            child: Stack(
                                              children: <Widget>[
                                                Center(
                                                  child: Text(
                                                    "Adkhar",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 25.0,
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
                        child: FutureBuilder<List<Section>>(
                            future: getallsection(helper),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return CustomScrollView(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    slivers: <Widget>[
                                      SliverGrid(
                                        gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10.0,
                                            mainAxisSpacing: 10.0),
                                        delegate: SliverChildBuilderDelegate(
                                                (BuildContext context,
                                                int index) {
                                              animationController.forward();
                                              return listItem(
                                                  index, snapshot.data);
                                            },
                                            childCount: snapshot.data.length),
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
        ],
      ),
    );
  }

  Widget listItem(int index, List<Section> data) {
    Section pSection = data[index];
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
                transform: new Matrix4.translationValues(
                    0.0,
                    30 *
                        (1.0 -
                            Tween<double>(begin: 0.0, end: 1.0)
                                .animate(CurvedAnimation(
                                parent: animationController,
                                curve: Interval(
                                    (1 / data.length) * index, 1.0,
                                    curve: Curves.fastOutSlowIn)))
                                .value),
                    0.0),
                child: Material(
                  borderRadius: BorderRadius.circular(6.0),
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Color(pSection.color),
                    borderRadius: BorderRadius.circular(6.0),
                    onTap: () {
                      animationController.duration =
                          Duration(milliseconds: 1000);
                      animationController.reverse().then<dynamic>((data) async {
                        if (!mounted) {
                          return;
                        }
                        int count = await getCount(helper, pSection.id);

                        if(count<=1)
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SingleDataList(
                                            section: pSection,

                                            animation: animationController)));
                          }
                        else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ListArticles(
                                          section: pSection,

                                          animation: animationController)));
                        }
                      });
                      ;
                    },
                    child: Container(
                      width: 150.0,
                      height: 170.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
//                                  boxShadow: [
//                                    BoxShadow(
//                                        blurRadius: 55,
//                                        offset: Offset(0.0, 15.0),
//                                        color: Color(producsts[index]['color']).withOpacity(0.16))
//                                  ],
                        color: Color(pSection.color).withOpacity(0.08),
                      ),
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: CachedNetworkImage(
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                            colorFilter: ColorFilter.mode(
                                                Color(pSection.color),
                                                BlendMode.srcATop)

                                        ),
                                      ),
                                    ),

                                imageUrl: pSection.image,
                                placeholder: (context, url) =>
                                    SizedBox(
                                        width: 10.0,
                                        height: 10.0,
                                        child: new CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                        )),
                                errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                              ),
                            ),
//                            Image(
//                              image: AssetImage(pSection.image),
//                              width: 50.0,
//                              color: Color(pSection.color),
//                              height: 50.0,
//                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                pSection.name,
                                style: TextStyle(
                                    color: Color(pSection.color),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ));
        });
  }

  Future<List<Section>> getallsection(SectionHelper dbHelper) async {
    List<Section> gSection = [];
    await dbHelper.getAllSections().then((value) {
      for (Section section in value) {
        gSection.add(section);
      }
    });
    return gSection;
  }

  Future<int> getCount(SectionHelper dbHelper, int id) async {
    int count = 0;
    await dbHelper.getCount(id).then((value) {
      count = value;
    });
    return count;
  }


}
class AnimatedBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onChange;

  const AnimatedBottomNavBar({Key key, this.currentIndex, this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () => onChange(0),
              child: BottomNavItem(
                icon: Icons.home,
                title: "Home",
                isActive: currentIndex == 0,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChange(1),
              child: BottomNavItem(
                icon: Icons.person,
                title: "User",
                isActive: currentIndex == 1,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChange(2),
              child: BottomNavItem(
                icon: Icons.add_shopping_cart,
                title: "Cart",
                isActive: currentIndex == 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final Color activeColor;
  final Color inactiveColor;
  final String title;

  const BottomNavItem({
    Key key,
    this.isActive = false,
    this.icon,
    this.activeColor,
    this.inactiveColor,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position:
//            TweenSequence([
//              TweenSequenceItem(
//                  tween: Tween<Offset>(
//                      begin: Offset(0.0, 0.3), end: Offset(0.0, 0.0)),
//                  weight: 2),
//              TweenSequenceItem(
//                  tween: ConstantTween(Offset(0.0, 0.0)), weight: 3),
//              TweenSequenceItem(
//                  tween: Tween<Offset>(
//                      begin: Offset(0.0, 0.0), end: Offset(0.0, -0.3)),
//                  weight: 2)
//            ]).animate(animation),
              Tween<Offset>(
            begin: const Offset(0.0, 0.3),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      duration: Duration(milliseconds: 500),
      reverseDuration: Duration(milliseconds: 200),
      child: isActive
          ? Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: activeColor ?? Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Container(
                    width: 5.0,
                    height: 5.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: activeColor ?? Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            )
          : Icon(
              icon,
              color: inactiveColor ?? Colors.black,
            ),
    );

//      AnimatedSwitcher(
//      transitionBuilder: (child, animation) {
//        return
//      },
//
//      duration: Duration(milliseconds: 500),
//      reverseDuration: Duration(milliseconds: 200),
//      child:
//    );
  }
}

//class ProductsTab extends StatelessWidget {
//  const ProductsTab(this.animationController, {Key key}) : super(key: key);
//  final AnimationController animationController;
//
//  @override
//  Widget build(BuildContext context) {
//    return
//  }
//}
