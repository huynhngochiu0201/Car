import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // SignUp User
  Future<String> signupUser({
    required String email,
    required String password,
    required String name,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        // Register user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Add user to your Firestore database with id field
        String userId = cred.user!.uid;
        await _firestore.collection("users").doc(userId).set({
          'name': name,
          'uid': userId,
          'email': email,
          // 'id': userId, // Adding the user id explicitly
        });

        res = "success";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logIn user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // Send password reset email
  Future<String> sendPasswordReset(String email) async {
    String res = "Some error Occurred";
    try {
      await _auth.sendPasswordResetEmail(email: email);
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Future<void> updateUserInfo({
  //   required String userId,
  //   String? name,
  //   String? avatar,
  // }) async {
  //   try {
  //     final userDoc = _firestore.collection('users').doc(userId);

  //     Map<String, dynamic> updates = {};
  //     if (name != null) updates['name'] = name;
  //     if (avatar != null) updates['avatar'] = avatar;

  //     await userDoc.update(updates);
  //   } catch (e) {
  //     throw Exception('Failed to update user information: $e');
  //   }
  // }

  // // Lấy thông tin người dùng bằng userId
  // Future<UserModel> getUserById(String userId) async {
  //   try {
  //     final snapshot = await _firestore.collection('users').doc(userId).get();
  //     if (snapshot.exists) {
  //       return UserModel.fromJson(snapshot.data()!);
  //     } else {
  //       throw Exception('User not found');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to fetch user: $e');
  //   }
  // }
}
