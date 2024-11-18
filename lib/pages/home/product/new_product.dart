import 'package:app_car_rescue/constants/app_color.dart';
import 'package:app_car_rescue/resources/double_extension.dart';
import 'package:app_car_rescue/utils/spaces.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../constants/app_style.dart';
import '../../../models/product_model.dart';
import 'product_detail_page.dart';

class NewProduct extends StatefulWidget {
  const NewProduct({super.key});

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  late Future<List<ProductModel>> _products;

  @override
  void initState() {
    super.initState();
    _products = fetchNewProducts(); // Gán giá trị cho _products khi khởi tạo
  }

  Future<List<ProductModel>> fetchNewProducts() async {
    // Lấy thời gian hiện tại trừ đi 7 ngày
    final DateTime sevenDaysAgo = DateTime.now().subtract(Duration(days: 30));

    final querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('createAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(sevenDaysAgo))
        .orderBy('createAt', descending: true)
        .limit(5)
        .get();

    return querySnapshot.docs
        .map((doc) => ProductModel.fromJson(doc.data()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: _products,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No new products found'));
        }

        final products = snapshot.data!;

        return SizedBox(
          height: 100.0,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 5.0),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(
                        productId: product.id,
                        product: product,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 213,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        spreadRadius: 0,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Image.network(
                            product.image,
                            height: 100.0,
                            width: 100.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      spaceW10,
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyle.regular_12),
                              spaceH6,
                              Text(product.price.toVND(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: AppStyle.regular_14),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 20.0),
            itemCount: products.length,
          ),
        );
      },
    );
  }
}
