import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_style.dart';
import '../../../utils/spaces.dart';

class CrRatingReview extends StatelessWidget {
  const CrRatingReview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<double> ratings = [0.1, 0.3, 0.7, 0.8, 0.9];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '4.9',
              style: AppStyle.bold_36.copyWith(fontFamily: 'Product Sans'),
            ),
            spaceW10,
            Text(
              'OUT OF 5 ',
              style: AppStyle.regular_12.copyWith(color: AppColor.grey500),
            ),
            Spacer(),
            RatingBar.readOnly(
              filledColor: AppColor.E508A7B,
              size: 25,
              filledIcon: Icons.star,
              emptyIcon: Icons.star_border,
              initialRating: 4,
              maxRating: 5,
            )
          ],
        ),
        spaceH14,
        SizedBox(
          width: 200.0,
          child: ListView.builder(
            shrinkWrap: true,
            reverse: true,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Text(
                    "${index + 1}",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(width: 4.0),
                  Icon(Icons.star, color: AppColor.E508A7B),
                  SizedBox(width: 8.0),
                  LinearPercentIndicator(
                    lineHeight: 6.0,
                    // linearStrokeCap: LinearStrokeCap.roundAll,
                    width: MediaQuery.of(context).size.width / 2.8,
                    animation: true,
                    animationDuration: 2500,
                    percent: ratings[index],
                    progressColor: AppColor.E508A7B,
                  ),
                ],
              );
            },
          ),
        ),
        spaceH10,
        Text('10 Reviws'),
        spaceH40,
        SizedBox(
          child: ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            reverse: true,
            itemCount: 5,
            itemBuilder: (context, index) {
              if (index >= 3) {
                return SizedBox.shrink();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        child: Image.asset('assets/images/Autocarlogo.png'),
                      ),
                      spaceW10,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('data'),
                          RatingBar.readOnly(
                            filledColor: AppColor.E508A7B,
                            size: 25,
                            filledIcon: Icons.star,
                            emptyIcon: Icons.star_border,
                            initialRating: 5,
                            maxRating: 5,
                          )
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                        'I love it. Awesome customer service!! Helped me out with adding an additional item to my order. Thanks again!'),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
