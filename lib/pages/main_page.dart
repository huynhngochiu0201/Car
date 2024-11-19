import 'package:app_car_rescue/pages/home/orders/orders_page.dart';
import 'package:flutter/material.dart';
import '../constants/app_color.dart';
import '../components/navigator/app_bottomnavbar1.dart';
import 'home/home_page.dart';
import 'home/map/map_page.dart';
import 'home/profile/profile_page.dart';

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
  late int selectedIndex;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.pageIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.bgColor,
        body: IndexedStack(
          index: currentIndex,
          children: const [
            HomePage(),
            MapPage(),
            OrdersPage(),
            ProfilePage(),
          ],
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
