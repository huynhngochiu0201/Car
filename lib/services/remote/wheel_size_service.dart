import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/wheel_size_model.dart';
import '../../resources/define_collection.dart';

class WheelSizeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<WheelSizeModel>> fetchAllWheelSizesByCreateAt() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(AppDefineCollection.APP_WHEEL_SIZE)
          .orderBy('createAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Gán id từ document Firestore
        return WheelSizeModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch wheel sizes: $e');
    }
  }
}
