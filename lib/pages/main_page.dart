import 'package:app_car_rescue/pages/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../components/app_bar/cr_app_bar.dart';
import 'drawer/cr_zoom_drawer.dart';
import 'drawer/drawer_page.dart';
import '../constants/app_color.dart';
import '../components/navigator/app_bottomnavbar1.dart';
import 'home/home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
    required this.title,
    this.pageIndex,
  });

  final String title;
  final int? pageIndex;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final zoomDrawerController = ZoomDrawerController();
  late int selectedIndex;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.pageIndex ?? 0;
  }

  toggleDrawer() {
    zoomDrawerController.toggle?.call();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.bgColor,
        appBar: CrAppBar(
          leftPressed: toggleDrawer,
          rightPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const LoginPage(),
          )),
          title: widget.title,
          // avatar: SharedPrefs.user?.avatar,
        ),
        body: CrZoomDrawer(
          controller: zoomDrawerController,
          menuScreen: DrawerPage(pageIndex: selectedIndex),
          screen: IndexedStack(
            index: currentIndex,
            children: const [
              HomePage(),
              // SearchPage(),
              // MapPage(),
              // CartPage(),
              // CalendarPage()
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBarCurvedFb1(
          selected: currentIndex,
          onPressed: (p0) {
            setState(() {
              currentIndex = p0;
            });
          },
        ),
      ),
    );
  }
}
