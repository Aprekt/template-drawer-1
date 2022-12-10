import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:template_drawer_1/core/constants/enums.dart';
import 'package:template_drawer_1/widget/side_drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<SideDrawerState> _sideDrawerKey =
      GlobalKey<SideDrawerState>();
  dynamic _sideDrawerState;
  bool _isAlignmentRight = false;
  SideDrawerType _selectedType = SideDrawerType.slide;

  //Drawer Menu
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

          //Drawer Menu Options
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

  //Custom Radio for Drawer Animation options
  Widget customRadioButton(String buttonName, SideDrawerType type) {
    return Row(
      children: [
        Radio(
          fillColor: MaterialStateColor.resolveWith((states) => Colors.blue),
          value: type,
          groupValue: _selectedType,
          onChanged: (value) {
            setState(() {
              _selectedType = value!;
            });
          },
        ),
        Text(
          buttonName,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SideDrawer(
      menu: buildMenu(),
      key: _sideDrawerKey,
      isAlignmentRight: _isAlignmentRight,
      type: _selectedType,
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
              _sideDrawerState = _sideDrawerKey.currentState;
              if (_sideDrawerState.isOpened) {
                _sideDrawerState.closeSideDrawer();
              } else {
                _sideDrawerState.openSideDrawer();
              }
            },
          ),
        ),
        body: Container(
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Center(
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
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 5, thickness: 1, color: Colors.grey),
                  ListTile(
                    textColor: Colors.white,
                    title: const Text("Drawer from right"),
                    trailing: Switch(
                      inactiveTrackColor: Colors.grey[400],
                      value: _isAlignmentRight,
                      onChanged: ((value) {
                        setState(() {
                          _isAlignmentRight = !_isAlignmentRight;
                        });
                      }),
                    ),
                  ),
                  const Center(
                    child: SizedBox(
                      width: 375,
                      child: Divider(
                        height: 5,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 14.0, top: 8.0),
                    child: Text(
                      "Drawer Animation:",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  customRadioButton("Slide", SideDrawerType.slide),
                  customRadioButton(
                      'Perspective Slide', SideDrawerType.slideWithPerspective),
                  customRadioButton(
                      'Slide and Shrink', SideDrawerType.slideWithShrink),
                  customRadioButton(
                      'Slide and Rotate', SideDrawerType.slideWithRotation),
                  customRadioButton('Slide, Shrink and Rotate',
                      SideDrawerType.slideShrinkWithRotation),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
