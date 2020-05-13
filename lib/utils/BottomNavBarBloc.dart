import 'dart:async';

enum NavBarItem { HOME, SEARCH, SETTINGS }

class BottomNavBarBloc {
  final StreamController<NavBarItem> navBarControler =
      StreamController<NavBarItem>.broadcast();

  NavBarItem defaultitem = NavBarItem.HOME;

  get _navBarControlers => this.navBarControler;




  void pickItem(int i) {
    switch (i) {
      case 0:
        navBarControler.sink.add(NavBarItem.HOME);
        break;
      case 1:
        navBarControler.sink.add(NavBarItem.SEARCH);
        break;
      case 2:
        navBarControler.sink.add(NavBarItem.SETTINGS);
        break;
    }
  }

  close() {
    navBarControler?.close();
  }
}
