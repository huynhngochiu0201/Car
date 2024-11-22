import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/service_model.dart';
import '../../resources/define_collection.dart';

class ServiceRequestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String get userId => _auth.currentUser!.email!;
  Future<void> submitRequest(ServiceModel request) async {
    try {
      await _firestore
          .collection(AppDefineCollection.APP_USER_SERVICE)
          .add(request.toJson());
    } catch (e) {
      throw Exception('Failed to submit request: $e');
    }
  }
}
