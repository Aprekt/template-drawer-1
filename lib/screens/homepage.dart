import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:template_drawer_1/widget/side_drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget buildMenu() {
    return SizedBox(
      height: 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DrawerHeader(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 50.0,
                  child: Image.asset("assets/Aprekt logo icon.png", scale: 3),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  "Aprekt",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.home, color: Colors.white),
                  title: const Text(
                    "Home",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.person, color: Colors.white),
                  title: const Text(
                    "Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.settings, color: Colors.white),
                  title: const Text(
                    "Settings",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text(
                    "Log out",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final GlobalKey<SideDrawerState> _sideMenuKey = GlobalKey<SideDrawerState>();
  dynamic _sideMenuState;

  @override
  Widget build(BuildContext context) {
    return SideDrawer(
      menu: buildMenu(),
      key: _sideMenuKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Drawer Template'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 16, 16, 16),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color.fromARGB(255, 16, 16, 16),
          ),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _sideMenuState = _sideMenuKey.currentState;
              if (_sideMenuState.isOpened) {
                _sideMenuState.closeSideDrawer();
              } else {
                _sideMenuState.openSideDrawer();
              }
            },
          ),
        ),
        body: Container(
          color: Colors.black,
          child: const Center(
            child: Text.rich(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
              TextSpan(
                children: [
                  TextSpan(text: "Press "),
                  WidgetSpan(
                      child: Icon(Icons.menu, color: Colors.white),
                      alignment: PlaceholderAlignment.middle),
                  TextSpan(text: " to open side drawer")
                ],
                style: TextStyle(color: Colors.white),
              ),
            ),
            // ,
          ),
        ),
      ),
    );
  }
}
