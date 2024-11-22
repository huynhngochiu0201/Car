import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/payload_model.dart';
import '../../resources/define_collection.dart';

class PayloadService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PayloadModel>> fetchAllPayloadsByCreateAt() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(AppDefineCollection.APP_PAYLOAD)
          .orderBy('createAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Gán id từ document Firestore
        return PayloadModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch payloads: $e');
    }
  }
}
