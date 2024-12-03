import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/add_checkout_model.dart';
import '../../resources/define_collection.dart';

// class CheckoutService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Lấy userId của người dùng hiện tại
//   String get userId => _auth.currentUser!.email!;

//   Future<String> placeOrder(AddCheckoutModel checkoutModel) async {
//     String res = "Some error occurred";
//     try {
//       await _firestore
//           .collection(AppDefineCollection.APP_ORDER)
//           .add(checkoutModel.toJson());
//       res = "Order placed successfully";
//     } catch (e) {
//       res = e.toString();
//     }
//     return res;
//   }
// }

class CheckoutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Lấy userId của người dùng hiện tại
  String get userId => _auth.currentUser!.email!;

  Future<String> placeOrder(AddCheckoutModel checkoutModel) async {
    String res = "Some error occurred";
    try {
      await _firestore
          .collection(AppDefineCollection.APP_ORDER)
          .add(checkoutModel.toJson());

      // Cập nhật số lượng sản phẩm sau khi đơn hàng được đặt thành công
      for (var item in checkoutModel.cartData) {
        await _updateProductQuantity(item.productId, item.quantity);
      }

      res = "Order placed successfully";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> _updateProductQuantity(
      String productId, int purchasedQuantity) async {
    final productRef = _firestore.collection('products').doc(productId);

    await _firestore.runTransaction((transaction) async {
      final docSnapshot = await transaction.get(productRef);

      if (!docSnapshot.exists) {
        throw Exception("Product does not exist!");
      }

      final currentQuantity = docSnapshot['quantity'] as int;
      final updatedQuantity = currentQuantity - purchasedQuantity;

      transaction.update(productRef, {
        'quantity': updatedQuantity,
      });
    });
  }
}
