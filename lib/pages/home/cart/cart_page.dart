// import 'package:flutter/material.dart';
// import 'package:app_car_rescue/models/cart_model.dart';
// import 'package:app_car_rescue/services/remote/cart_service.dart';
// import 'package:app_car_rescue/constants/app_style.dart';
// import 'package:app_car_rescue/constants/app_color.dart';
// import 'package:app_car_rescue/components/app_bar/custom_app_bar.dart';
// import 'package:app_car_rescue/components/snack_bar/td_snack_bar.dart';
// import 'package:app_car_rescue/components/snack_bar/top_snack_bar.dart';
// import 'package:app_car_rescue/pages/home/cart/widget/draggableScrollableSheet.dart';
// import 'package:app_car_rescue/resources/double_extension.dart';
// import 'package:app_car_rescue/utils/spaces.dart';

// class CartPage extends StatefulWidget {
//   const CartPage({super.key});

//   @override
//   CartPageState createState() => CartPageState();
// }

// class CartPageState extends State<CartPage> {
//   final CartService _cartService = CartService();
//   late List<CartModel> _cartItemsList = [];
//   late Stream<List<CartModel>> _cartItemsStream;
//   bool _isLoading = false;
//   final List<CartModel> _selectedItems = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchCartItems();
//   }

//   void _fetchCartItems() {
//     _cartItemsStream = _cartService.getCartStream();
//     _cartItemsStream.listen((cartItems) {
//       setState(() {
//         _cartItemsList = cartItems;
//       });
//     });
//   }

//   Future<void> _refreshCart() async {
//     _fetchCartItems();
//   }

//   Future<void> _removeItem(String productId) async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       String res = await _cartService.removeFromCart(productId);
//       showTopSnackBar(context, TDSnackBar.success(message: res));
//       _fetchCartItems();
//       _selectedItems.removeWhere((item) => item.productId == productId);
//     } catch (e) {
//       showTopSnackBar(
//           context, TDSnackBar.error(message: 'Error: ${e.toString()}'));
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _removeOnlySelectedItems() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       for (var item in _selectedItems) {
//         await _cartService.removeFromCart(item.productId);
//       }
//       showTopSnackBar(context,
//           TDSnackBar.success(message: 'Checked items removed from cart'));
//       _fetchCartItems();
//       _selectedItems.clear();
//     } catch (e) {
//       showTopSnackBar(
//           context, TDSnackBar.error(message: 'Error: ${e.toString()}'));
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _updateQuantity(CartModel cartItem, int newQuantity) async {
//     if (newQuantity < 1) return;
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       await _cartService.updateQuantity(cartItem.productId, newQuantity);
//       _fetchCartItems();
//     } catch (e) {
//       showTopSnackBar(
//           context, TDSnackBar.error(message: 'Error: ${e.toString()}'));
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _toggleSelection(CartModel cartItem, bool? isSelected) async {
//     setState(() {
//       cartItem.isChecked = isSelected ?? false;
//       if (cartItem.isChecked) {
//         if (!_selectedItems
//             .any((item) => item.productId == cartItem.productId)) {
//           _selectedItems.add(cartItem);
//         }
//       } else {
//         _selectedItems
//             .removeWhere((item) => item.productId == cartItem.productId);
//       }
//     });

//     try {
//       await _cartService.updateCheckboxStatus(
//           cartItem.productId, cartItem.isChecked);
//       print('Checkbox status updated on Firebase');
//     } catch (e) {
//       showTopSnackBar(
//         context,
//         TDSnackBar.error(
//             message: 'Failed to update checkbox status: ${e.toString()}'),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(title: 'Your Cart'),
//       backgroundColor: AppColor.white,
//       body: Stack(
//         children: [
//           StreamBuilder<List<CartModel>>(
//             stream: _cartItemsStream,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return const Center(child: Text('Your cart is empty'));
//               }

//               final cartItems = snapshot.data!;

//               return RefreshIndicator(
//                 onRefresh: _refreshCart,
//                 child: ListView.builder(
//                   itemCount: cartItems.length,
//                   itemBuilder: (context, index) {
//                     final cartItem = cartItems[index];
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 15.0, horizontal: 20.0),
//                       child: Container(
//                         height: 110.0,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(35.0),
//                           boxShadow: const [
//                             BoxShadow(
//                                 color: Colors.black26,
//                                 offset: Offset(0, 2),
//                                 blurRadius: 20.0)
//                           ],
//                         ),
//                         child: Row(
//                           children: [
//                             Container(
//                               width: 100.0,
//                               decoration: BoxDecoration(
//                                 borderRadius: const BorderRadius.only(
//                                   topLeft: Radius.circular(20),
//                                   bottomLeft: Radius.circular(20.0),
//                                 ),
//                                 color: AppColor.white,
//                                 image: DecorationImage(
//                                   image: NetworkImage(cartItem.productImage),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 10.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         SizedBox(
//                                           width: 150.0,
//                                           child: Text(
//                                             cartItem.productName,
//                                             style: AppStyle.bold_14,
//                                             overflow: TextOverflow.ellipsis,
//                                             maxLines: 1,
//                                           ),
//                                         ),
//                                         Checkbox(
//                                           value: cartItem.isChecked,
//                                           onChanged: (value) =>
//                                               _toggleSelection(cartItem, value),
//                                         ),
//                                       ],
//                                     ),
//                                     Text(cartItem.productPrice.toVND(),
//                                         style: AppStyle.bold_16),
//                                     spaceH6,
//                                     Row(
//                                       children: [
//                                         Container(
//                                           height: 28.0,
//                                           width: 75.0,
//                                           decoration: BoxDecoration(
//                                             border: Border.all(
//                                                 width: 2, color: Colors.grey),
//                                             borderRadius:
//                                                 BorderRadius.circular(20.0),
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 8.0),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     if (cartItem.quantity > 1) {
//                                                       _updateQuantity(
//                                                           cartItem,
//                                                           cartItem.quantity -
//                                                               1);
//                                                     }
//                                                   },
//                                                   child: const Icon(
//                                                       Icons.remove,
//                                                       color: Colors.grey,
//                                                       size: 12.0),
//                                                 ),
//                                                 Text(
//                                                   cartItem.quantity.toString(),
//                                                   style: AppStyle.bold_12
//                                                       .copyWith(
//                                                           color: Colors.grey),
//                                                 ),
//                                                 GestureDetector(
//                                                   onTap: () => _updateQuantity(
//                                                       cartItem,
//                                                       cartItem.quantity + 1),
//                                                   child: const Icon(Icons.add,
//                                                       color: Colors.grey,
//                                                       size: 12.0),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         const Spacer(),
//                                         GestureDetector(
//                                           onTap: () {
//                                             showDialog(
//                                               context: context,
//                                               builder: (context) => AlertDialog(
//                                                 title: const Text('Confirm'),
//                                                 content: const Text(
//                                                     'Are you sure you want to remove this item from the cart?'),
//                                                 actions: [
//                                                   TextButton(
//                                                     onPressed: () =>
//                                                         Navigator.pop(context),
//                                                     child: const Text('Cancel'),
//                                                   ),
//                                                   TextButton(
//                                                     onPressed: () {
//                                                       _removeItem(
//                                                           cartItem.productId);
//                                                       Navigator.pop(context);
//                                                     },
//                                                     child: const Text('Remove'),
//                                                   ),
//                                                 ],
//                                               ),
//                                             );
//                                           },
//                                           child: const Padding(
//                                             padding:
//                                                 EdgeInsets.only(right: 10.0),
//                                             child: Icon(Icons.delete,
//                                                 color: Colors.grey),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const Spacer(),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           ),
//           DraggbleScrollable(
//             cartItems: _cartItemsStream,
//             selectedItems: _selectedItems,
//             onCheckoutComplete: _removeOnlySelectedItems,
//           ),
//           if (_isLoading)
//             Container(
//               color: Colors.black.withOpacity(0.3),
//               child: const Center(child: CircularProgressIndicator()),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:app_car_rescue/models/cart_model.dart';
import 'package:app_car_rescue/services/remote/cart_service.dart';
import 'package:app_car_rescue/constants/app_style.dart';
import 'package:app_car_rescue/constants/app_color.dart';
import 'package:app_car_rescue/components/app_bar/custom_app_bar.dart';
import 'package:app_car_rescue/components/snack_bar/td_snack_bar.dart';
import 'package:app_car_rescue/components/snack_bar/top_snack_bar.dart';
import 'package:app_car_rescue/pages/home/cart/widget/draggableScrollableSheet.dart';
import 'package:app_car_rescue/resources/double_extension.dart';
import 'package:app_car_rescue/utils/spaces.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();
  late List<CartModel> _cartItemsList = [];
  late Stream<List<CartModel>> _cartItemsStream;
  bool _isLoading = false;
  final List<CartModel> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  void _fetchCartItems() {
    _cartItemsStream = _cartService.getCartStream();
    _cartItemsStream.listen((cartItems) {
      setState(() {
        _cartItemsList = cartItems;
      });
    });
  }

  Future<void> _removeItem(String productId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await _cartService.removeFromCart(productId);
      showTopSnackBar(context, TDSnackBar.success(message: res));
      _fetchCartItems();
      _selectedItems.removeWhere((item) => item.productId == productId);
    } catch (e) {
      showTopSnackBar(
          context, TDSnackBar.error(message: 'Error: ${e.toString()}'));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _removeOnlySelectedItems() async {
    setState(() {
      _isLoading = true;
    });
    try {
      for (var item in _selectedItems) {
        await _cartService.removeFromCart(item.productId);
      }
      showTopSnackBar(context,
          TDSnackBar.success(message: 'Checked items removed from cart'));
      _fetchCartItems();
      _selectedItems.clear();
    } catch (e) {
      showTopSnackBar(
          context, TDSnackBar.error(message: 'Error: ${e.toString()}'));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateQuantity(CartModel cartItem, int newQuantity) async {
    if (newQuantity < 1) return;
    setState(() {
      _isLoading = true;
    });
    try {
      await _cartService.updateQuantity(cartItem.productId, newQuantity);
      _fetchCartItems();
    } catch (e) {
      showTopSnackBar(
          context, TDSnackBar.error(message: 'Error: ${e.toString()}'));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleSelection(CartModel cartItem, bool? isSelected) async {
    setState(() {
      cartItem.isChecked = isSelected ?? false;
      if (cartItem.isChecked) {
        if (!_selectedItems
            .any((item) => item.productId == cartItem.productId)) {
          _selectedItems.add(cartItem);
        }
      } else {
        _selectedItems
            .removeWhere((item) => item.productId == cartItem.productId);
      }
    });

    try {
      await _cartService.updateCheckboxStatus(
          cartItem.productId, cartItem.isChecked);
      print('Checkbox status updated on Firebase');
    } catch (e) {
      showTopSnackBar(
        context,
        TDSnackBar.error(
            message: 'Failed to update checkbox status: ${e.toString()}'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Your Cart'),
      backgroundColor: AppColor.white,
      body: Stack(
        children: [
          StreamBuilder<List<CartModel>>(
            stream: _cartItemsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Your cart is empty'));
              }

              final cartItems = snapshot.data!;

              return ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartItems[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    child: Container(
                      height: 110.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35.0),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 20.0),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 100.0,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20.0),
                              ),
                              color: AppColor.white,
                              image: DecorationImage(
                                image: NetworkImage(cartItem.productImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
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
                                        value: cartItem.isChecked,
                                        onChanged: (value) =>
                                            _toggleSelection(cartItem, value),
                                      ),
                                    ],
                                  ),
                                  Text(cartItem.productPrice.toVND(),
                                      style: AppStyle.bold_16),
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
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (cartItem.quantity > 1) {
                                                    _updateQuantity(cartItem,
                                                        cartItem.quantity - 1);
                                                  }
                                                },
                                                child: const Icon(
                                                  Icons.remove,
                                                  color: Colors.grey,
                                                  size: 12.0,
                                                ),
                                              ),
                                              Text(
                                                cartItem.quantity.toString(),
                                                style: AppStyle.bold_12
                                                    .copyWith(
                                                        color: Colors.grey),
                                              ),
                                              GestureDetector(
                                                onTap: () => _updateQuantity(
                                                    cartItem,
                                                    cartItem.quantity + 1),
                                                child: const Icon(
                                                  Icons.add,
                                                  color: Colors.grey,
                                                  size: 12.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Confirm'),
                                              content: const Text(
                                                  'Are you sure you want to remove this item from the cart?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    _removeItem(
                                                        cartItem.productId);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Remove'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(right: 10.0),
                                          child: Icon(Icons.delete,
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          DraggbleScrollable(
            cartItems: _cartItemsStream,
            selectedItems: _selectedItems,
            onCheckoutComplete: _removeOnlySelectedItems,
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
