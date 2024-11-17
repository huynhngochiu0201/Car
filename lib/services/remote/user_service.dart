// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class UserService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Get user info by userId
//   Future<Map<String, dynamic>> getUserById(String userId) async {
//     try {
//       final userDoc = await _firestore.collection('users').doc(userId).get();
//       if (userDoc.exists) {
//         return userDoc.data()!;
//       } else {
//         throw Exception("User not found");
//       }
//     } catch (e) {
//       throw Exception('Failed to fetch user data: $e');
//     }
//   }

//   // Get current authenticated user's info
//   Future<Map<String, dynamic>> getCurrentUserInfo() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       throw Exception('No user is currently logged in');
//     }
//     try {
//       final userDoc = await _firestore.collection('users').doc(user.uid).get();
//       if (userDoc.exists) {
//         return userDoc.data()!;
//       } else {
//         throw Exception("User document not found in Firestore");
//       }
//     } catch (e) {
//       throw Exception('Failed to get current user info: $e');
//     }
//   }
// }
