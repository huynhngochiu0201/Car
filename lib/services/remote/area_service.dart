import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/area_model.dart';
import '../../resources/define_collection.dart';

class AreaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AreaModel>> fetchAllAreasByCreateAt() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(AppDefineCollection.APP_AREA)
          .orderBy('createAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Gán id từ document Firestore
        return AreaModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch areas: $e');
    }
  }
}
