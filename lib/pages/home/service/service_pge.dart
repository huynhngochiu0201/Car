import 'package:app_car_rescue/components/app_bar/custom_app_bar.dart';
import 'package:app_car_rescue/constants/app_color.dart';
import 'package:app_car_rescue/pages/home/service/replacement.dart';
import 'package:app_car_rescue/pages/home/service/towing_and_winching.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../utils/spaces.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBar(title: AppLocalizations.of(context)?.service ?? 'Service'),
      body: Column(
        children: [
          spaceH10,
          Container(
            height: 40.0,
            padding: const EdgeInsets.all(6.0),
            margin: const EdgeInsets.symmetric(horizontal: 25.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.0),
              color: Colors.transparent,
            ),
            child: TabBar(
              dividerColor: Colors.transparent,
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(22.0),
                  color: AppColor.E43484B),
              labelColor: Colors.white,
              tabs: [
                Tab(
                    text: AppLocalizations.of(context)?.replaceTire ??
                        'Replace tire'),
                Tab(text: AppLocalizations.of(context)?.rescue ?? 'Rescue'),
              ],
            ),
          ),
          spaceH10,
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: const [
                Replacement(),
                TowingAndWinching(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
