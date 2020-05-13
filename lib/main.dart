
import 'package:adhkaar/database/modelhelper/DuaHeadingHelper.dart';
import 'package:adhkaar/screens/browse_screens.dart';
import 'package:adhkaar/screens/searchScreen.dart';
import 'package:adhkaar/screens/subdivisionview.dart';
import 'package:adhkaar/utils/BottomNavBarBloc.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigation_dot_bar/navigation_dot_bar.dart';
import 'package:provider/provider.dart';

import 'database/helper/Helper.dart';


void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var dbHelper = Helper();

    final _duaHeading = DuaHeadingHelper(dbHelper.db);
    return MultiProvider(
      providers: [
        Provider<DuaHeadingHelper>.value(value: _duaHeading),
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

  @override
  void initState() {
    super.initState();
    _bottomNavBarBloc = BottomNavBarBloc();
  }

  @override
  void dispose() {
    _bottomNavBarBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

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
                    return BrowseScreen();
                  case NavBarItem.SEARCH:
                    return SearchScreen();
                  case NavBarItem.SETTINGS:
                    return BrowseScreen();
                  default:
                    return BrowseScreen();
                }
              }),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 75,
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
                    StreamBuilder(
                  stream: _bottomNavBarBloc.navBarControler.stream,
                  initialData: _bottomNavBarBloc.defaultitem,
                  builder: (BuildContext context,
                      AsyncSnapshot<NavBarItem> snapshot) {
                    return BottomNavigationDotBar(
                        // Usar -> "BottomNavigationDotBar"
                        items: <BottomNavigationDotBarItem>[
                          BottomNavigationDotBarItem(
                              icon: FeatherIcons.grid,
                              onTap: () {
                                _bottomNavBarBloc.pickItem(0);
                              }),
                          BottomNavigationDotBarItem(
                              icon: FeatherIcons.search,
                              onTap: () {
                                _bottomNavBarBloc.pickItem(1);
                              }),
                          BottomNavigationDotBarItem(
                              icon: FeatherIcons.user,
                              onTap: () {
                                _bottomNavBarBloc.pickItem(2);
                              }),
                        ]);
                  },
                ),
              )),
        ],
      ),
    ));
  }
}
