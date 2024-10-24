import 'package:app_car_rescue/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../resources/define_collection.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final querySnapshot = await _firestore
          .collection(AppDefineCollection.APP_CATEGORY)
          .orderBy('createAt', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => CategoryModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }
}
