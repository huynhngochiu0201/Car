// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:car_app/models/product_model.dart';
// import 'package:car_app/resources/define_collection.dart';

// class ProductService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;

//   // Future<List<ProductModel>> fetchProducts() async {
//   //   try {
//   //     final snapshot =
//   //         await _db.collection(AppDefineCollection.APP_PRODUCT).get();
//   //     return snapshot.docs
//   //         .map((doc) => ProductModel.fromJson(doc.data()))
//   //         .toList();
//   //   } catch (e) {
//   //     throw Exception('Failed to fetch products: $e');
//   //   }
//   // }

//   //

//   Future<List<ProductModel>> fetchProducts() async {
//     try {
//       final snapshot =
//           await _db.collection(AppDefineCollection.APP_PRODUCT).get();
//       return snapshot.docs
//           .map((doc) => ProductModel.fromJson(doc.data()))
//           .toList();
//     } catch (e) {
//       throw Exception('Failed to fetch products: $e');
//     }
//   }

//   Future<void> addProduct(ProductModel product) async {
//     try {
//       await _db
//           .collection(AppDefineCollection.APP_PRODUCT)
//           .add(product.toJson());
//     } catch (e) {
//       throw Exception('Failed to add product: $e');
//     }
//   }

//   Future<void> updateProduct(String id, ProductModel product) async {
//     try {
//       await _db
//           .collection(AppDefineCollection.APP_PRODUCT)
//           .doc(id)
//           .update(product.toJson());
//     } catch (e) {
//       throw Exception('Failed to update product: $e');
//     }
//   }

//   Future<void> deleteProduct(String id) async {
//     try {
//       await _db.collection(AppDefineCollection.APP_PRODUCT).doc(id).delete();
//     } catch (e) {
//       throw Exception('Failed to delete product: $e');
//     }
//   }

//   Future<List<ProductModel>> fetchProductsByCategory(String categoryId) async {
//     try {
//       final querySnapshot = await _db
//           .collection(AppDefineCollection.APP_PRODUCT)
//           .where('categoryId', isEqualTo: categoryId)
//           .get();

//       return querySnapshot.docs
//           .map((doc) => ProductModel.fromJson(doc.data()))
//           .toList();
//     } catch (e) {
//       throw Exception('Error fetching products: $e');
//     }
//   }

//   static Future<List<ProductModel>> getProductsByCategoryId(
//       String categoryId) async {
//     try {
//       // Fetch products from Firestore based on categoryId
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('products') // Adjust with your Firestore collection name
//           .where('categoryId', isEqualTo: categoryId)
//           .get();

//       // Map the fetched documents to ProductModel
//       final products = querySnapshot.docs.map((doc) {
//         return ProductModel.fromJson(
//             doc.data()); // Adjust based on your ProductModel implementation
//       }).toList();

//       return products; // Return the list of products
//     } catch (e) {
//       print('Error fetching products: $e'); // Handle error appropriately
//       throw Exception(
//           'Failed to load products'); // Throw an exception for the calling function to handle
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/product_model.dart';
import '../../resources/define_collection.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final snapshot =
          await _db.collection(AppDefineCollection.APP_PRODUCT).get();
      return snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      await _db
          .collection(AppDefineCollection.APP_PRODUCT)
          .add(product.toJson());
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  Future<void> updateProduct(String id, ProductModel product) async {
    try {
      await _db
          .collection(AppDefineCollection.APP_PRODUCT)
          .doc(id)
          .update(product.toJson());
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _db.collection(AppDefineCollection.APP_PRODUCT).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  Future<List<ProductModel>> fetchProductsByCategory(String categoryId) async {
    try {
      final querySnapshot = await _db
          .collection(AppDefineCollection.APP_PRODUCT)
          .where('categoryId', isEqualTo: categoryId)
          .get();

      return querySnapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products by category: $e');
    }
  }
}
