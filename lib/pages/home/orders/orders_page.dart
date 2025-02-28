import 'package:app_car_rescue/constants/app_color.dart';
import 'package:app_car_rescue/constants/app_style.dart';
import 'package:app_car_rescue/pages/home/orders/widget/Cancelled_page.dart';
import 'package:app_car_rescue/pages/home/orders/widget/service_item_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app_car_rescue/utils/spaces.dart';
import 'package:flutter/material.dart';
import '../../../components/app_bar/cr_app_bar.dart';
import 'widget/delivered_page.dart';
import 'widget/pending_page.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CrAppBar(),
      backgroundColor: AppColor.white,
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
              unselectedLabelStyle: AppStyle.regular_12,
              dividerColor: Colors.transparent,
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(22.0),
                  color: AppColor.E43484B),
              labelColor: Colors.white,
              tabs: [
                Tab(
                  child: Text(
                    AppLocalizations.of(context)?.service ?? 'Service',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Tab(
                  child: Text(
                    AppLocalizations.of(context)?.pending ?? 'Pending',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Tab(
                  child: Text(
                    AppLocalizations.of(context)?.delivered ?? 'Delivered',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Tab(
                  child: Text(
                    AppLocalizations.of(context)?.cancelled ?? 'Cancelled',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          spaceH10,
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: const [
                ServiceItemPage(),
                PendingPage(),
                DeliveredPage(),
                CancelledPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
