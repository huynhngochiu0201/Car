import 'package:app_car_rescue/constants/app_color.dart';
import 'package:app_car_rescue/constants/app_style.dart';
import 'package:app_car_rescue/utils/spaces.dart';
import 'package:flutter/material.dart';

class NewProduct extends StatefulWidget {
  const NewProduct({
    super.key,
  });

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.separated(
          physics: ScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: AppColor.green500),
                  height: 172.0,
                  width: 126.0,
                ),
                spaceH14,
                Text(
                  'data',
                  style: AppStyle.regular_12,
                ),
                spaceH4,
                Text(
                  'data',
                  style: AppStyle.bold_16,
                )
              ],
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 20.0,
            );
          },
          itemCount: 10),
    );
  }
}
