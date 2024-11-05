import 'package:app_car_rescue/constants/app_color.dart';
import 'package:app_car_rescue/constants/app_style.dart';
import 'package:app_car_rescue/pages/home/product/rating_bar.dart';
import 'package:app_car_rescue/resources/double_extension.dart';
import 'package:app_car_rescue/utils/spaces.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../components/snack_bar/td_snack_bar.dart';
import '../../../components/snack_bar/top_snack_bar.dart';
import '../../../gen/assets.gen.dart';
import '../../../models/cart_model.dart';
import '../../../models/product_model.dart';
import '../../../services/remote/cart_service.dart';
import 'new_product.dart';

class ItemProduct extends StatefulWidget {
  final ProductModel product;

  const ItemProduct({super.key, required this.product});

  @override
  State<ItemProduct> createState() => _ItemProductState();
}

class _ItemProductState extends State<ItemProduct> {
  final CartService _cartService = CartService();
  bool isExpanded = false;
  bool _isAddingToCart = false;
  bool isFavorite = false;
  bool _isDescriptionExpanded = true;
  bool _isReviewsExpanded = true;
  final bool _isNewProduct = true;

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
        userId: user.uid,
        productId: widget.product.id.toString(),
        productName: widget.product.name,
        productImage: widget.product.image,
        productPrice: widget.product.price,
        quantity: 1, // Mặc định thêm 1 sản phẩm
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
                                    setState(() {
                                      isFavorite = !isFavorite;
                                    });
                                  },
                                  child: Center(
                                    child: SvgPicture.asset(
                                      height: 18,
                                      width: 18,
                                      Assets.icons.heart1,
                                      color:
                                          isFavorite ? Colors.red : Colors.grey,
                                    ),
                                  ),
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
                                  color: Colors.black.withOpacity(
                                      0.5), // Ensure enough opacity
                                  spreadRadius:
                                      1, // You can increase this for a larger shadow
                                  blurRadius: 5, // Increase to make it softer
                                  offset:
                                      const Offset(0, 2), // Adjust as necessary
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
                      if (_isReviewsExpanded) CrRatingBar(),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 9.0),
                      //   child: Align(
                      //     alignment: Alignment.topLeft,
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Text(
                      //           'New Product',
                      //           style: AppStyle.bold_16.copyWith(
                      //               fontFamily: 'Product Sans Medium'),
                      //         ),
                      //         GestureDetector(
                      //             onTap: () {
                      //               setState(() {
                      //                 _isNewProduct = !_isNewProduct;
                      //               });
                      //             },
                      //             child: Container(
                      //               height: 20.0,
                      //               width: 20.0,
                      //               decoration:
                      //                   BoxDecoration(shape: BoxShape.circle),
                      //               child: Center(
                      //                 child: SvgPicture.asset(
                      //                     height: 10.0,
                      //                     width: 10.0,
                      //                     Assets.icons.dropdownButton),
                      //               ),
                      //             )),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Divider(),
                      // spaceH20,
                      // if (_isNewProduct) NewProduct(),
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
