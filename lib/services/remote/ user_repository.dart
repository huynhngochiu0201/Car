// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:app_car_rescue/models/user_model.dart';

// class UserRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<UserModel> getUserById(String userId) async {
//     try {
//       final snapshot = await _firestore.collection('users').doc(userId).get();
//       if (snapshot.exists) {
//         return UserModel.fromJson(snapshot.data()!);
//       } else {
//         throw Exception('User not found');
//       }
//     } catch (e) {
//       throw Exception('Failed to fetch user: $e');
//     }
//   }
// }
