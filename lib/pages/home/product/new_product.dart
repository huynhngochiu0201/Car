// // import 'package:app_car_rescue/constants/app_color.dart';
// // import 'package:app_car_rescue/utils/spaces.dart';
// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import '../../../models/product_model.dart';
// // import '../product/item_produc.dart';

// // class NewProduct extends StatefulWidget {
// //   const NewProduct({super.key});

// //   @override
// //   State<NewProduct> createState() => _NewProductState();
// // }

// // class _NewProductState extends State<NewProduct> {
// //   late Future<List<ProductModel>> _products;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _products = fetchProducts(); // Gọi hàm để gán giá trị cho _products
// //   }

// // // Hàm lấy dữ liệu từ Firestore
// //   Future<List<ProductModel>> fetchProducts() async {
// //     final querySnapshot = await FirebaseFirestore.instance
// //         .collection('products')
// //         .orderBy('createAt', descending: true)
// //         .limit(10) // Giới hạn số lượng sản phẩm trả về
// //         .get();

// //     return querySnapshot.docs
// //         .map((doc) => ProductModel.fromJson(doc.data()))
// //         .toList();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return FutureBuilder<List<ProductModel>>(
// //       future: _products,
// //       builder: (context, snapshot) {
// //         if (snapshot.connectionState == ConnectionState.waiting) {
// //           return const Center(child: CircularProgressIndicator());
// //         } else if (snapshot.hasError) {
// //           return Center(child: Text('Error: ${snapshot.error}'));
// //         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //           return const Center(child: Text('No new products found'));
// //         }

// //         final products = snapshot.data!;

// //         return SizedBox(
// //           height: 230,
// //           child: ListView.separated(
// //             padding: EdgeInsets.symmetric(horizontal: 32.0),
// //             scrollDirection: Axis.horizontal,
// //             itemBuilder: (context, index) {
// //               final product = products[index];
// //               return GestureDetector(
// //                 onTap: () {
// //                   Navigator.push(
// //                     context,
// //                     MaterialPageRoute(
// //                       builder: (context) => ItemProduct(
// //                         product: product,
// //                       ),
// //                     ),
// //                   );
// //                 },
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Container(
// //                       height: 170.0,
// //                       width: 126.0,
// //                       decoration: BoxDecoration(
// //                         color: AppColor.white,
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: Colors.grey.withOpacity(0.8),
// //                             spreadRadius: 0,
// //                             blurRadius: 3,
// //                             offset: const Offset(0, 2),
// //                           ),
// //                         ],
// //                         borderRadius: BorderRadius.circular(10.0),
// //                       ),
// //                       child: ClipRRect(
// //                         borderRadius: BorderRadius.circular(10.0),
// //                         child: Align(
// //                           alignment: Alignment.topLeft,
// //                           child: Image.network(
// //                             product.image,
// //                             height: 170.0,
// //                             width: 126.0,
// //                             fit: BoxFit.cover,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     spaceH6,
// //                     Text('data'),
// //                     Text('data')
// //                   ],
// //                 ),
// //               );
// //             },
// //             separatorBuilder: (context, index) => const SizedBox(width: 20.0),
// //             itemCount: products.length,
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }

// // import 'package:custom_rating_bar/custom_rating_bar.dart';
// // import 'package:flutter/material.dart';
// // import 'package:percent_indicator/linear_percent_indicator.dart';

// // import '../../../constants/app_color.dart';
// // import '../../../constants/app_style.dart';
// // import '../../../utils/spaces.dart';

// // class CrRatingBar extends StatelessWidget {
// //   const CrRatingBar({
// //     super.key,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     List<double> ratings = [0.1, 0.3, 0.7, 0.8, 0.9];
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Row(
// //           children: [
// //             Text(
// //               '4.9',
// //               style: AppStyle.bold_36.copyWith(fontFamily: 'Product Sans'),
// //             ),
// //             spaceW10,
// //             Text(
// //               'OUT OF 5 ',
// //               style: AppStyle.regular_12.copyWith(color: AppColor.grey500),
// //             ),
// //             Spacer(),
// //             RatingBar.readOnly(
// //               filledColor: AppColor.E508A7B,
// //               size: 25,
// //               filledIcon: Icons.star,
// //               emptyIcon: Icons.star_border,
// //               initialRating: 4,
// //               maxRating: 5,
// //             )
// //           ],
// //         ),
// //         spaceH14,
// //         SizedBox(
// //           width: 200.0,
// //           child: ListView.builder(
// //             shrinkWrap: true,
// //             reverse: true,
// //             itemCount: 5,
// //             itemBuilder: (context, index) {
// //               return Row(
// //                 children: [
// //                   Text(
// //                     "${index + 1}",
// //                     style: TextStyle(fontSize: 18.0),
// //                   ),
// //                   SizedBox(width: 4.0),
// //                   Icon(Icons.star, color: AppColor.E508A7B),
// //                   SizedBox(width: 8.0),
// //                   LinearPercentIndicator(
// //                     lineHeight: 6.0,
// //                     // linearStrokeCap: LinearStrokeCap.roundAll,
// //                     width: MediaQuery.of(context).size.width / 2.8,
// //                     animation: true,
// //                     animationDuration: 2500,
// //                     percent: ratings[index],
// //                     progressColor: AppColor.E508A7B,
// //                   ),
// //                 ],
// //               );
// //             },
// //           ),
// //         ),
// //         spaceH10,
// //         Text('10 Reviws'),
// //         spaceH40,
// //         SizedBox(
// //           child: ListView.builder(
// //             shrinkWrap: true,
// //             physics: ScrollPhysics(),
// //             reverse: true,
// //             itemCount: 5,
// //             itemBuilder: (context, index) {
// //               if (index >= 3) {
// //                 return SizedBox.shrink();
// //               }
// //               return Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Row(
// //                     children: [
// //                       CircleAvatar(
// //                         child: Image.asset('assets/images/Autocarlogo.png'),
// //                       ),
// //                       spaceW10,
// //                       Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text('data'),
// //                           RatingBar.readOnly(
// //                             filledColor: AppColor.E508A7B,
// //                             size: 25,
// //                             filledIcon: Icons.star,
// //                             emptyIcon: Icons.star_border,
// //                             initialRating: 5,
// //                             maxRating: 5,
// //                           )
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                   Padding(
// //                     padding: const EdgeInsets.symmetric(vertical: 20.0),
// //                     child: Text(
// //                         'I love it. Awesome customer service!! Helped me out with adding an additional item to my order. Thanks again!'),
// //                   ),
// //                 ],
// //               );
// //             },
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // import 'package:custom_rating_bar/custom_rating_bar.dart';
// // import 'package:flutter/material.dart';
// // import 'package:percent_indicator/linear_percent_indicator.dart';

// // import '../../../constants/app_color.dart';
// // import '../../../constants/app_style.dart';
// // import '../../../utils/spaces.dart';

// // class CrRatingBar extends StatelessWidget {
// //   const CrRatingBar({
// //     super.key,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     List<double> ratings = [0.1, 0.3, 0.7, 0.8, 0.9];
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Row(
// //           children: [
// //             Text(
// //               '4.9',
// //               style: AppStyle.bold_36.copyWith(fontFamily: 'Product Sans'),
// //             ),
// //             spaceW10,
// //             Text(
// //               'OUT OF 5 ',
// //               style: AppStyle.regular_12.copyWith(color: AppColor.grey500),
// //             ),
// //             Spacer(),
// //             RatingBar.readOnly(
// //               filledColor: AppColor.E508A7B,
// //               size: 25,
// //               filledIcon: Icons.star,
// //               emptyIcon: Icons.star_border,
// //               initialRating: 4,
// //               maxRating: 5,
// //             )
// //           ],
// //         ),
// //         spaceH14,
// //         SizedBox(
// //           width: 200.0,
// //           child: ListView.builder(
// //             shrinkWrap: true,
// //             reverse: true,
// //             itemCount: 5,
// //             itemBuilder: (context, index) {
// //               return Row(
// //                 children: [
// //                   Text(
// //                     "${index + 1}",
// //                     style: TextStyle(fontSize: 18.0),
// //                   ),
// //                   SizedBox(width: 4.0),
// //                   Icon(Icons.star, color: AppColor.E508A7B),
// //                   SizedBox(width: 8.0),
// //                   LinearPercentIndicator(
// //                     lineHeight: 6.0,
// //                     // linearStrokeCap: LinearStrokeCap.roundAll,
// //                     width: MediaQuery.of(context).size.width / 2.8,
// //                     animation: true,
// //                     animationDuration: 2500,
// //                     percent: ratings[index],
// //                     progressColor: AppColor.E508A7B,
// //                   ),
// //                 ],
// //               );
// //             },
// //           ),
// //         ),
// //         spaceH10,
// //         Text('10 Reviws'),
// //         spaceH40,
// //         SizedBox(
// //           child: ListView.builder(
// //             shrinkWrap: true,
// //             physics: ScrollPhysics(),
// //             reverse: true,
// //             itemCount: 5,
// //             itemBuilder: (context, index) {
// //               if (index >= 3) {
// //                 return SizedBox.shrink();
// //               }
// //               return Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Row(
// //                     children: [
// //                       CircleAvatar(
// //                         child: Image.asset('assets/images/Autocarlogo.png'),
// //                       ),
// //                       spaceW10,
// //                       Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text('data'),
// //                           RatingBar.readOnly(
// //                             filledColor: AppColor.E508A7B,
// //                             size: 25,
// //                             filledIcon: Icons.star,
// //                             emptyIcon: Icons.star_border,
// //                             initialRating: 5,
// //                             maxRating: 5,
// //                           )
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                   Padding(
// //                     padding: const EdgeInsets.symmetric(vertical: 20.0),
// //                     child: Text(
// //                         'I love it. Awesome customer service!! Helped me out with adding an additional item to my order. Thanks again!'),
// //                   ),
// //                 ],
// //               );
// //             },
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
// import 'package:custom_rating_bar/custom_rating_bar.dart';

// import '../../../constants/app_color.dart';
// import '../../../constants/app_style.dart';
// import '../../../utils/spaces.dart';
// import '../../../services/remote/review_service.dart';
// import '../../../models/review_model.dart';

// class CrRatingBar extends StatelessWidget {
//   final String productId;
//   final ReviewService reviewService = ReviewService();

//   CrRatingBar({
//     super.key,
//     required this.productId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<ReviewModel>>(
//       future: reviewService.getReviews(productId),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return Text('Error loading reviews');
//         }

//         List<ReviewModel> reviews = snapshot.data ?? [];

//         if (reviews.isEmpty) {
//           return Text('No reviews yet');
//         }

//         double averageRating = _calculateAverageRating(reviews);
//         List<double> ratings = _calculateRatingPercentages(reviews);

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   averageRating.toStringAsFixed(1),
//                   style: AppStyle.bold_36.copyWith(fontFamily: 'Product Sans'),
//                 ),
//                 spaceW10,
//                 Text(
//                   'OUT OF 5 ',
//                   style: AppStyle.regular_12.copyWith(color: AppColor.grey500),
//                 ),
//                 Spacer(),
//                 RatingBar.readOnly(
//                   filledColor: AppColor.E508A7B,
//                   size: 25,
//                   filledIcon: Icons.star,
//                   emptyIcon: Icons.star_border,
//                   initialRating: averageRating,
//                   maxRating: 5,
//                 ),
//               ],
//             ),
//             spaceH14,
//             SizedBox(
//               width: 200.0,
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 reverse: true,
//                 itemCount: 5,
//                 itemBuilder: (context, index) {
//                   return Row(
//                     children: [
//                       Text(
//                         "${index + 1}",
//                         style: TextStyle(fontSize: 18.0),
//                       ),
//                       SizedBox(width: 4.0),
//                       Icon(Icons.star, color: AppColor.E508A7B),
//                       SizedBox(width: 8.0),
//                       LinearPercentIndicator(
//                         lineHeight: 6.0,
//                         width: MediaQuery.of(context).size.width / 2.8,
//                         animation: true,
//                         animationDuration: 2500,
//                         percent: ratings[index],
//                         progressColor: AppColor.E508A7B,
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             spaceH10,
//             Text('${reviews.length} Reviews'),
//             spaceH40,
//             ListView.builder(
//               shrinkWrap: true,
//               physics: ScrollPhysics(),
//               itemCount: reviews.length > 3 ? 3 : reviews.length,
//               itemBuilder: (context, index) {
//                 final review = reviews[index];
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           child: Icon(Icons.person),
//                         ),
//                         spaceW10,
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                                 'User ID: ${review.userId}'), // Hiển thị userId
//                             RatingBar.readOnly(
//                               filledColor: AppColor.E508A7B,
//                               size: 20,
//                               filledIcon: Icons.star,
//                               emptyIcon: Icons.star_border,
//                               initialRating: review.rating,
//                               maxRating: 5,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 10.0),
//                       child: Text(review.comment),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   List<double> _calculateRatingPercentages(List<ReviewModel> reviews) {
//     List<int> counts = List.filled(5, 0);

//     for (var review in reviews) {
//       int index = review.rating.floor() - 1;
//       if (index >= 0 && index < 5) {
//         counts[index]++;
//       }
//     }

//     int total = reviews.length;
//     return counts.map((count) => count / total).toList();
//   }

//   double _calculateAverageRating(List<ReviewModel> reviews) {
//     if (reviews.isEmpty) return 0;
//     double sum = reviews.fold(0, (sum, review) => sum + review.rating);
//     return sum / reviews.length;
//   }
// }
