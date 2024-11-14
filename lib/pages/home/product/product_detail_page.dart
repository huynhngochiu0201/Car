import 'package:app_car_rescue/constants/app_color.dart';
import 'package:app_car_rescue/constants/app_style.dart';
import 'package:app_car_rescue/resources/double_extension.dart';
import 'package:app_car_rescue/utils/spaces.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../components/snack_bar/td_snack_bar.dart';
import '../../../components/snack_bar/top_snack_bar.dart';
import '../../../gen/assets.gen.dart';
import '../../../models/cart_model.dart';
import '../../../models/product_model.dart';
import '../../../models/review_model.dart';
import '../../../services/remote/cart_service.dart';
import '../../../services/remote/review_service.dart';
import '../cart/cart_page.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;
  final String productId;

  const ProductDetailPage(
      {super.key, required this.product, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final CartService _cartService = CartService();
  bool isExpanded = false;
  bool _isAddingToCart = false;
  bool _isDescriptionExpanded = true;
  bool _isReviewsExpanded = true;

  final ReviewService _reviewService = ReviewService();
  final List<ReviewModel> _reviews = []; // Remove 'final'

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReviewData();
  }

  Future<void> _loadReviewData() async {
    try {
      setState(() => _isLoading = true);

      // Load reviews and rating stats concurrently
      final results = await Future.wait([
        _reviewService.getProductReviews(widget.product.id),
        _reviewService.getProductRatingStats(widget.product.id),
      ]);

      setState(() {
        _reviews.addAll(results[0] as List<ReviewModel>);

        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      showTopSnackBar(
          context, TDSnackBar.error(message: 'Error loading reviews: $e'));
    }
  }

  Future<void> _addProductToCart() async {
    setState(() {
      _isAddingToCart = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _isAddingToCart = false;
        });
        showTopSnackBar(
          context,
          const TDSnackBar.error(message: 'Please log in to add items to cart'),
        );
        return;
      }

      CartModel cartItem = CartModel(
        userId: user.email!,
        productId: widget.product.id.toString(),
        productName: widget.product.name,
        productImage: widget.product.image,
        productPrice: widget.product.price,
        quantity: 1,
      );
      String res = await _cartService.addToCart(cartItem);
      showTopSnackBar(
        context,
        TDSnackBar.success(message: res),
      );
    } catch (e) {
      showTopSnackBar(
        context,
        TDSnackBar.error(message: 'Error: ${e.toString()}'),
      );
    } finally {
      setState(() {
        _isAddingToCart = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: ListView(
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 451,
                          child: Image.network(
                            widget.product.image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Center(child: Icon(Icons.error)),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          top: 48.0,
                          left: 20.0,
                          right: 20.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.8),
                                        spreadRadius: 0,
                                        blurRadius: 3,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.arrow_back),
                                ),
                              ),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.8),
                                      spreadRadius: 0,
                                      blurRadius: 3,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  shape: BoxShape.circle,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CartPage()));
                                  },
                                  child:
                                      Center(child: Icon(Icons.shopping_cart)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 420,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 50.0,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              color: AppColor.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.product.name,
                            style: AppStyle.bold_18
                                .copyWith(fontFamily: 'Product Sans Medium'),
                          ),
                          Text(
                            widget.product.price.toVND(),
                            style: AppStyle.bold_24
                                .copyWith(fontFamily: 'Product Sans Medium'),
                          ),
                        ],
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child: RatingBar.readOnly(
                            filledColor: AppColor.E508A7B,
                            size: 19.0,
                            filledIcon: Icons.star,
                            emptyIcon: Icons.star_border,
                            initialRating: 4,
                            maxRating: 5,
                          )),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 9.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Description',
                                style: AppStyle.bold_16.copyWith(
                                    fontFamily: 'Product Sans Medium'),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isDescriptionExpanded =
                                          !_isDescriptionExpanded;
                                    });
                                  },
                                  child: Container(
                                    height: 20.0,
                                    width: 20.0,
                                    decoration:
                                        BoxDecoration(shape: BoxShape.circle),
                                    child: Center(
                                      child: SvgPicture.asset(
                                          height: 10.0,
                                          width: 10.0,
                                          Assets.icons.dropdownButton),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      if (_isDescriptionExpanded) _buildProductDescription(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 9.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Reviews',
                                style: AppStyle.bold_16.copyWith(
                                    fontFamily: 'Product Sans Medium'),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isReviewsExpanded = !_isReviewsExpanded;
                                    });
                                  },
                                  child: Container(
                                    height: 20.0,
                                    width: 20.0,
                                    decoration:
                                        BoxDecoration(shape: BoxShape.circle),
                                    child: Center(
                                      child: SvgPicture.asset(
                                          height: 10.0,
                                          width: 10.0,
                                          Assets.icons.dropdownButton),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      if (_isReviewsExpanded)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '4.9',
                                  style: AppStyle.bold_36
                                      .copyWith(fontFamily: 'Product Sans'),
                                ),
                                spaceW10,
                                Text(
                                  'OUT OF 5 ',
                                  style: AppStyle.regular_12
                                      .copyWith(color: AppColor.grey500),
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
                            // SizedBox(
                            //   width: 200.0,
                            //   child: ListView.builder(
                            //     shrinkWrap: true,
                            //     reverse: true,
                            //     itemCount: 5,
                            //     itemBuilder: (context, index) {
                            //       return Row(
                            //         children: [
                            //           Text(
                            //             "${index + 1}",
                            //             style: TextStyle(fontSize: 18.0),
                            //           ),
                            //           SizedBox(width: 4.0),
                            //           Icon(Icons.star, color: AppColor.E508A7B),
                            //           SizedBox(width: 8.0),
                            //           LinearPercentIndicator(
                            //             lineHeight: 6.0,
                            //             // linearStrokeCap: LinearStrokeCap.roundAll,
                            //             width:
                            //                 MediaQuery.of(context).size.width /
                            //                     2.8,
                            //             animation: true,
                            //             animationDuration: 2500,
                            //             // percent: _ratingStats[],

                            //             progressColor: AppColor.E508A7B,
                            //           ),
                            //         ],
                            //       );
                            //     },
                            //   ),
                            // ),
                            spaceH10,
                            Text(' lấy tổng số bao nhiêu  Reviws'),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            child:
                                                Image.asset('ảnh người review'),
                                          ),
                                          spaceW10,
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('tê người review'),
                                              RatingBar.readOnly(
                                                filledColor: AppColor.E508A7B,
                                                size: 25,
                                                filledIcon: Icons.star,
                                                emptyIcon: Icons.star_border,
                                                initialRating: 5,
                                                maxRating: 5,
                                              )

                                              /// đưa vào 1 hàm để lấy dữ liệu rating từ firebase
                                            ],
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20.0),
                                        child: Text('Nội dung review'),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      spaceH10,
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildBottomRow(),
        ],
      ),
    );
  }

  Widget _buildProductDescription() {
    return RichText(
      text: TextSpan(
        text: isExpanded || widget.product.description.length <= 200
            ? widget.product.description
            : '${widget.product.description.substring(0, 200)}...',
        style: AppStyle.regular_12.copyWith(fontFamily: 'Product Sans Light'),
        children: [
          if (!isExpanded && widget.product.description.length > 200)
            TextSpan(
              text: ' Read more',
              style: const TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    isExpanded = true;
                  });
                },
            ),
          if (isExpanded && widget.product.description.length > 200)
            TextSpan(
              text: ' Show less',
              style: const TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    isExpanded = false;
                  });
                },
            ),
        ],
      ),
    );
  }

  Widget _buildBottomRow() {
    return GestureDetector(
      onTap: _isAddingToCart ? null : _addProductToCart,
      child: Container(
        height: 62.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.E343434,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(Assets.icons.filled),
            spaceW10,
            Text(
              _isAddingToCart ? 'Adding...' : 'Add to Cart',
              style: AppStyle.bold_18.copyWith(color: AppColor.white),
            ),
          ],
        ),
      ),
    );
  }
}
