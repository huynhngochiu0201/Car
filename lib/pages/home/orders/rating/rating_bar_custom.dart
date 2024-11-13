import 'package:app_car_rescue/components/app_bar/custom_app_bar.dart';
import 'package:app_car_rescue/components/button/cr_elevated_button.dart';
import 'package:app_car_rescue/constants/app_color.dart';
import 'package:app_car_rescue/constants/app_style.dart';
import 'package:app_car_rescue/utils/spaces.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../services/remote/review_service.dart';

class RatingBarCustom extends StatefulWidget {
  final List<Map<String, dynamic>>
      products; // Danh sách sản phẩm trong đơn hàng

  const RatingBarCustom({super.key, required this.products});

  @override
  State<RatingBarCustom> createState() => _RatingBarCustomState();
}

class _RatingBarCustomState extends State<RatingBarCustom> {
  final List<Map<String, dynamic>> _reviews = [];

  @override
  void initState() {
    super.initState();
    for (var product in widget.products) {
      _reviews.add({
        'productId': product['productId'],
        'rating': 0.0,
        'comment': TextEditingController(),
      });
    }
  }

  Future<void> _submitReviews() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to submit a review')),
      );
      return;
    }

    for (var review in _reviews) {
      if (review['rating'] > 0 && review['comment'].text.isNotEmpty) {
        await ReviewService().submitReview(
          userEmail: user.email!, // Sử dụng email người dùng thay vì UID
          productId: review['productId'],
          rating: review['rating'],
          comment: review['comment'].text,
        );
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reviews submitted successfully')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Rate Product'),
      backgroundColor: AppColor.white,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.products.length,
              itemBuilder: (context, index) {
                var product = widget.products[index];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            product['productImage']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  spaceW10,
                                  Text(product['productName'],
                                      style: AppStyle.bold_16),
                                ],
                              ),
                            ),
                            const Divider(height: 1),
                            spaceH10,
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                children: [
                                  const Text('Product reviews:'),
                                  spaceW10,
                                  RatingBar(
                                    filledIcon: Icons.star,
                                    emptyIcon: Icons.star_border,
                                    filledColor: AppColor.E508A7B,
                                    size: 30.0,
                                    maxRating: 5,
                                    initialRating: _reviews[index]['rating'],
                                    onRatingChanged: (rating) {
                                      setState(() {
                                        _reviews[index]['rating'] = rating;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              child: TextFormField(
                                controller: _reviews[index]['comment'],
                                maxLines: 4,
                                decoration: InputDecoration(
                                  hintStyle: AppStyle.regular_12
                                      .copyWith(color: AppColor.grey500),
                                  hintText:
                                      'Would you like to write anything about this product?',
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0)
                .copyWith(bottom: 20.0),
            child: CrElevatedButton(
              onPressed: _submitReviews,
              text: 'Submit Review',
            ),
          ),
        ],
      ),
    );
  }
}
