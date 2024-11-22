import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/add_checkout_model.dart';
import '../../resources/define_collection.dart';

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
      res = "Order placed successfully";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
