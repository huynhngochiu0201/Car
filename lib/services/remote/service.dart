import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/service_model.dart';
import '../../resources/define_collection.dart';

class ServiceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ServiceModel>> fetchServices() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(AppDefineCollection.APP_USER_SERVICE)
          .get();
      return snapshot.docs.map((doc) {
        return ServiceModel.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }).toList();
    } catch (e) {
      throw Exception('Failed to load services: $e');
    }
  }
}
