// import 'package:app_car_rescue/constants/app_color.dart';
// import 'package:app_car_rescue/utils/spaces.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../../models/product_model.dart';
// import '../product/item_produc.dart';

// class NewProduct extends StatefulWidget {
//   const NewProduct({super.key});

//   @override
//   State<NewProduct> createState() => _NewProductState();
// }

// class _NewProductState extends State<NewProduct> {
//   late Future<List<ProductModel>> _products;

//   @override
//   void initState() {
//     super.initState();
//     _products = fetchProducts(); // Gọi hàm để gán giá trị cho _products
//   }

// // Hàm lấy dữ liệu từ Firestore
//   Future<List<ProductModel>> fetchProducts() async {
//     final querySnapshot = await FirebaseFirestore.instance
//         .collection('products')
//         .orderBy('createAt', descending: true)
//         .limit(10) // Giới hạn số lượng sản phẩm trả về
//         .get();

//     return querySnapshot.docs
//         .map((doc) => ProductModel.fromJson(doc.data()))
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<ProductModel>>(
//       future: _products,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(child: Text('No new products found'));
//         }

//         final products = snapshot.data!;

//         return SizedBox(
//           height: 230,
//           child: ListView.separated(
//             padding: EdgeInsets.symmetric(horizontal: 32.0),
//             scrollDirection: Axis.horizontal,
//             itemBuilder: (context, index) {
//               final product = products[index];
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ItemProduct(
//                         product: product,
//                       ),
//                     ),
//                   );
//                 },
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       height: 170.0,
//                       width: 126.0,
//                       decoration: BoxDecoration(
//                         color: AppColor.white,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.8),
//                             spreadRadius: 0,
//                             blurRadius: 3,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(10.0),
//                         child: Align(
//                           alignment: Alignment.topLeft,
//                           child: Image.network(
//                             product.image,
//                             height: 170.0,
//                             width: 126.0,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ),
//                     spaceH6,
//                     Text('data'),
//                     Text('data')
//                   ],
//                 ),
//               );
//             },
//             separatorBuilder: (context, index) => const SizedBox(width: 20.0),
//             itemCount: products.length,
//           ),
//         );
//       },
//     );
//   }
// }
