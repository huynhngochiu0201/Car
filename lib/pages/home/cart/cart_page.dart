import 'package:app_car_rescue/components/app_bar/custom_app_bar.dart';
import 'package:app_car_rescue/constants/app_style.dart';
import 'package:app_car_rescue/gen/assets.gen.dart';
import 'package:app_car_rescue/pages/home/cart/widget/draggableScrollableSheet.dart';
import 'package:app_car_rescue/resources/double_extension.dart';
import 'package:app_car_rescue/utils/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../components/snack_bar/td_snack_bar.dart';
import '../../../components/snack_bar/top_snack_bar.dart';
import '../../../constants/app_color.dart';
import '../../../models/cart_model.dart';
import '../../../services/remote/cart_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();
  late Stream<List<CartModel>> _cartItems;
  bool? isChecked = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  void _fetchCartItems() {
    _cartItems = _cartService.getCartStream();
  }

  // Hàm để làm mới dữ liệu khi kéo xuống
  Future<void> _refreshCart() async {
    setState(() {
      _fetchCartItems();
    });
    _cartItems;
  }

  // Hàm để xóa sản phẩm khỏi giỏ hàng
  Future<void> _removeItem(String productId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await _cartService.removeFromCart(productId);
      showTopSnackBar(
        context,
        TDSnackBar.success(message: res),
      );
      _fetchCartItems();
    } catch (e) {
      showTopSnackBar(
        context,
        TDSnackBar.error(message: 'Error: ${e.toString()}'),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Hàm để cập nhật số lượng sản phẩm (tăng hoặc giảm)
  Future<void> _updateQuantity(CartModel cartItem, int newQuantity) async {
    if (newQuantity < 1) return;

    setState(() {
      _isLoading = true;
    });
    try {
      await _cartService.updateQuantity(cartItem.productId, newQuantity);
      // showTopSnackBar(
      //   context,
      //   const TDSnackBar.success(message: 'Quantity updated '),
      // );

      _fetchCartItems();
    } catch (e) {
      showTopSnackBar(
        context,
        TDSnackBar.error(message: 'Error: ${e.toString()}'),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'You Cart'),
      backgroundColor: AppColor.white,
      body: Stack(
        children: [
          StreamBuilder<List<CartModel>>(
            stream: _cartItems,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Giỏ hàng của bạn trống'));
              }

              final cartItems = snapshot.data!;

              return RefreshIndicator(
                onRefresh: _refreshCart,
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    final cartItem = cartItems[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      child: Container(
                        height: 110.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 20.0,
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 100.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20.0)),
                                color: AppColor.white,
                                image: DecorationImage(
                                  image: NetworkImage(cartItem.productImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 150.0,
                                          child: Text(
                                            cartItem.productName,
                                            style: AppStyle.bold_14,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Checkbox(
                                          value: isChecked,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              isChecked = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    Text(
                                      cartItem.productPrice.toVND(),
                                      style: AppStyle.bold_16,
                                    ),
                                    spaceH6,
                                    Row(
                                      children: [
                                        Container(
                                          height: 28.0,
                                          width: 75.0,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 2, color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (cartItem.quantity > 1) {
                                                      _updateQuantity(
                                                          cartItem,
                                                          cartItem.quantity -
                                                              1);
                                                    }
                                                  },
                                                  child: Icon(
                                                    FontAwesomeIcons.minus,
                                                    color: Colors.grey,
                                                    size: 12.0,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10.0),
                                                  child: Text(
                                                      cartItem.quantity
                                                          .toString(),
                                                      style: AppStyle.bold_12
                                                          .copyWith(
                                                              color:
                                                                  Colors.grey)),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _updateQuantity(cartItem,
                                                        cartItem.quantity + 1);
                                                  },
                                                  child: Icon(
                                                    FontAwesomeIcons.plus,
                                                    color: Colors.grey,
                                                    size: 12.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text('Xác nhận'),
                                                content: const Text(
                                                    'Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text('Hủy'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      _removeItem(
                                                          cartItem.productId);
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Xóa'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: SvgPicture.asset(
                                              Assets.icons.deleteSvgrepoCom,
                                              height: 25.0,
                                              width: 25.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer()
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          DraggbleScrollable(cartItems: _cartItems),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
