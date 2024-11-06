// import 'package:app_car_rescue/resources/double_extension.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// import '../../../../components/button/cr_elevated_button.dart';
// import '../../../../constants/app_color.dart';
// import '../../../../constants/app_style.dart';

// class PendingPage extends StatefulWidget {
//   const PendingPage({super.key});

//   @override
//   PendingPageState createState() => PendingPageState();
// }

// class PendingPageState extends State<PendingPage> {
//   // Retrieve the current user's ID
//   String get userId => FirebaseAuth.instance.currentUser!.uid;

//   // Stream to fetch only orders with 'Pending' status
//   Stream<QuerySnapshot> fetchPendingOrders() {
//     return FirebaseFirestore.instance
//         .collection('orders')
//         .where('uId', isEqualTo: userId)
//         .where('status', isEqualTo: 'Pending') // Filter for Pending status
//         .snapshots();
//   }

//   Future<void> _refreshOrders() async {
//     setState(() {}); // Trigger UI refresh
//     await Future.delayed(const Duration(seconds: 1));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: StreamBuilder<QuerySnapshot>(
//         stream: fetchPendingOrders(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return const Center(child: Text('Something went wrong!'));
//           } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No pending orders found'));
//           }

//           var orders = snapshot.data!.docs;

//           return RefreshIndicator(
//             onRefresh: _refreshOrders,
//             child: ListView.builder(
//               padding:
//                   const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//               itemCount: orders.length,
//               itemBuilder: (BuildContext context, int index) {
//                 var order = orders[index];
//                 DateTime createdAt = order['createdAt'].toDate();
//                 double totalPrice = (order['totalPrice'] as num).toDouble();
//                 String orderId = order.id;
//                 String status = order['status'];

//                 // Cast data to Map<String, dynamic> to access fields with containsKey

//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 20.0),
//                   child: Container(
//                     padding: const EdgeInsets.all(20.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10.0),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           blurRadius: 5,
//                           offset: Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Order #$orderId',
//                               style: AppStyle.bold_18,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Subtotal: ${(totalPrice.toVND())}',
//                               style: AppStyle.regular_14,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             Text(
//                               DateFormat('dd/MM/yyyy').format(createdAt),
//                               style: AppStyle.regular_14,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               status,
//                               style: AppStyle.regular_14.copyWith(
//                                 color: AppColor.ECF6212,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             CrElevatedButton.outline(
//                               onPressed: () {},
//                               text: 'Details',
//                               width: 100.0,
//                               height: 35.0,
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:app_car_rescue/resources/double_extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../../../components/button/cr_elevated_button.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_style.dart';

class PendingPage extends StatefulWidget {
  const PendingPage({super.key});

  @override
  PendingPageState createState() => PendingPageState();
}

class PendingPageState extends State<PendingPage> {
  // Retrieve the current user's ID
  String get userId => FirebaseAuth.instance.currentUser!.uid;

  // Stream to fetch only orders with 'Pending' status
  Stream<QuerySnapshot> fetchPendingOrders() {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('uId', isEqualTo: userId)
        .where('status', isEqualTo: 'Pending') // Filter for Pending status
        .snapshots();
  }

  Future<void> _refreshOrders() async {
    setState(() {}); // Trigger UI refresh
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: fetchPendingOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No pending orders found'));
          }

          var orders = snapshot.data!.docs;

          return RefreshIndicator(
            onRefresh: _refreshOrders,
            child: ListView.builder(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              itemCount: orders.length,
              itemBuilder: (BuildContext context, int index) {
                var order = orders[index];
                DateTime createdAt = order['createdAt'].toDate();
                double totalPrice = (order['totalPrice'] as num).toDouble();
                String orderId = order.id;
                String status = order['status'];

                // Calculate total quantity from cartData if it exists
                int totalQuantity = 0;
                final data = order.data() as Map<String, dynamic>;
                if (data.containsKey('cartData')) {
                  List<dynamic> cartData = data['cartData'];
                  totalQuantity = cartData.fold(0, (sum, item) {
                    return sum + ((item['quantity'] as num?)?.toInt() ?? 0);
                  });
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order #$orderId',
                              style: AppStyle.bold_18,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          DateFormat('dd/MM/yyyy').format(createdAt),
                          style: AppStyle.regular_14,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Quantity: $totalQuantity', // Display total quantity
                              style: AppStyle.regular_14,
                            ),
                            Text(
                              'Subtotal: ${(totalPrice.toVND())}',
                              style: AppStyle.regular_14,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              status,
                              style: AppStyle.regular_14.copyWith(
                                color: AppColor.ECF6212,
                              ),
                            ),
                            CrElevatedButton.outline(
                              onPressed: () {},
                              text: 'Details',
                              width: 100.0,
                              height: 35.0,
                            )
                          ],
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
    );
  }
}
