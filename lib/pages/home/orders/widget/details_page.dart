// import 'package:app_car_rescue/components/app_bar/custom_app_bar.dart';
// import 'package:app_car_rescue/constants/app_color.dart';
// import 'package:app_car_rescue/utils/spaces.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';

// class DetailsPage extends StatefulWidget {
//   const DetailsPage({super.key});

//   @override
//   _DetailsPageState createState() => _DetailsPageState();
// }

// class _DetailsPageState extends State<DetailsPage> {
//   String get userId => FirebaseAuth.instance.currentUser!.uid;

//   Stream<QuerySnapshot> fetchOrdersByUserId() {
//     return FirebaseFirestore.instance
//         .collection('orders')
//         .where('uId', isEqualTo: userId)
//         .snapshots();
//   }

//   Future<void> _refreshOrders() async {
//     setState(() {});
//     await Future.delayed(const Duration(seconds: 1));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       appBar: CustomAppBar(title: 'Order'),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
//               child: Container(
//                 height: 92.0,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: AppColor.white,
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 20)
//                       .copyWith(left: 34),
//                   child: Row(
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Order number',
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black),
//                           ),
//                           Text(
//                             'Delivery address',
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(width: 20),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // Orders list with StreamBuilder inside
//             StreamBuilder<QuerySnapshot>(
//               stream: fetchOrdersByUserId(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return const Center(child: Text('Something went wrong!'));
//                 } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(child: Text('No orders found'));
//                 }

//                 var orders = snapshot.data!.docs;

//                 return RefreshIndicator(
//                   onRefresh: _refreshOrders,
//                   child: ListView.builder(
//                     shrinkWrap:
//                         true, // Allows ListView to be inside SingleChildScrollView
//                     physics:
//                         const NeverScrollableScrollPhysics(), // Disable ListView scrolling
//                     itemCount: orders.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       var order = orders[index];
//                       var cartData = order['cartData'];
//                       var totalPrice = order['totalPrice'];

//                       return Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10.0)
//                             .copyWith(bottom: 10.0),
//                         child: Container(
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(5.0),
//                           ),
//                           child: Column(
//                             children: [
//                               ListView.builder(
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 itemCount: cartData.length,
//                                 itemBuilder: (context, itemIndex) {
//                                   var product = cartData[itemIndex];
//                                   return Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                             horizontal: 10.0)
//                                         .copyWith(bottom: 10.0),
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                           width: 70.0,
//                                           height: 70.0,
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(5.0),
//                                             color: Colors.white,
//                                             image: DecorationImage(
//                                               image: NetworkImage(
//                                                   product['productImage']),
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child: Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 10.0),
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   product['productName'],
//                                                   maxLines: 2,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   style: TextStyle(
//                                                       fontSize: 14,
//                                                       fontWeight:
//                                                           FontWeight.bold),
//                                                 ),
//                                                 const SizedBox(height: 8.0),
//                                                 Align(
//                                                   alignment: Alignment.topRight,
//                                                   child: Text(
//                                                     'x${product['quantity']}',
//                                                     style:
//                                                         TextStyle(fontSize: 14),
//                                                   ),
//                                                 ),
//                                                 Align(
//                                                   alignment: Alignment.topRight,
//                                                   child: Text(
//                                                     NumberFormat.currency(
//                                                             symbol: 'VND: ',
//                                                             decimalDigits: 0)
//                                                         .format(product[
//                                                             'productPrice']),
//                                                     style:
//                                                         TextStyle(fontSize: 14),
//                                                   ),
//                                                 ),
//                                                 const SizedBox(height: 8.0),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),
//                               Divider(
//                                 height: 1.0,
//                                 color: AppColor.grey,
//                               ),
//                               spaceH10,
//                               Align(
//                                 alignment: Alignment.topRight,
//                                 child: Text(
//                                   'Total:',
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16.0),
//                                 ),
//                               ),
//                               const SizedBox(height: 10.0),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:app_car_rescue/constants/app_color.dart';
import 'package:app_car_rescue/utils/spaces.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const DetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> cartData = order['cartData'] ?? [];
    final String orderId = order['orderId'] ?? '';
    final double totalPrice = order['totalPrice'] ?? 0.0;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: Text('Order Details')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Container(
                height: 92.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20)
                      .copyWith(left: 34),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order number: $orderId',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Total: ${NumberFormat.currency(symbol: 'VND ').format(totalPrice)}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cartData.length,
              itemBuilder: (context, index) {
                var product = cartData[index];
                return GestureDetector(
                  onTap: () {
                    // Handle tap on product item here, e.g., show product details
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0)
                        .copyWith(bottom: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              image: DecorationImage(
                                image: NetworkImage(product['productImage']),
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
                                  Text(
                                    product['productName'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      'Quantity: ${product['quantity']}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      NumberFormat.currency(
                                              symbol: 'VND ', decimalDigits: 0)
                                          .format(product['productPrice']),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
