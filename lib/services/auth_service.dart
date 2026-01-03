import 'dart:io';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_project/extensions/firestore_extension.dart';
import 'package:uas_project/models/users_model.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _userRef = FirebaseFirestore.instance.collection('users');
  // final NotificationService notifService = NotificationService();

  Future<String?> register(
    String username,
    String email,
    String password,
  ) async {
    final userCheck = await _userRef
        .where("username", isEqualTo: username)
        .limit(1)
        .get();

    if (userCheck.docs.isNotEmpty) return "Username already used";

    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _userRef.doc(cred.user!.uid).set({
        "fullname": "",
        "username": username,
        "email": email,
        "bio": "",
        "photo": "",
        "headerBanner": "",
        "role": "user",
        "isActive": true,
      });

      // notifService.createPersonalNotif(cred.user!.uid, 'welcome');

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = cred.user!.uid;
      final userDoc = await _userRef.doc(uid).get();

      if (!userDoc.exists) {
        await logout();
        return "User not found";
      }

      if (userDoc['isActive'] == false) {
        await logout();
        return "Your account is unactive";
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', uid);
      await prefs.setString('userLevel', userDoc["role"]);

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    final snapshot = await _userRef.get();
    return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
  }

  Future<UserModel> getProfile() async {
    final uid = _auth.currentUser!.uid;

    final doc = await _userRef.doc(uid).get();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', uid);
    await prefs.setString('userLevel', doc["role"]);

    return UserModel.fromFirestore(doc);
  }

  Future<UserModel> getUserByID(String idUser) async {
    final doc = await _userRef.doc(idUser).get();
    if (!doc.exists) {
      throw Exception('User not found');
    }
    return UserModel.fromFirestore(doc);
  }

  Future<List<UserModel>> getConsultant() async {
    final snapshot = await _userRef
        .where("role", isEqualTo: 'counsultant')
        .get();

    return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
  }

  Future<UserModel> getUserByUsername(String username) async {
    final query = await _userRef
        .where("username", isEqualTo: username)
        .limit(1)
        .get();

    return UserModel.fromFirestore(query.docs.first);
  }

  Future<List<UserModel>> searchUser(String query) async {
    final snapshot = await _userRef.get();

    final q = query.toLowerCase();

    final results = snapshot.docs
        .map((doc) => UserModel.fromFirestore(doc))
        .where(
          (user) =>
              user.email.toLowerCase().contains(q) ||
              user.username.toLowerCase().contains(q),
        )
        .toList();

    return results;
  }

  Future<String> setAdmin(bool add, String idUser) async {
    try {
      final userCheck = await _userRef.doc(idUser).get();

      if (!userCheck.exists) {
        return "User tidak ada";
      }

      await _userRef.doc(idUser).update({'role': add ? 'admin' : 'user'});

      // notifService.createPersonalNotif(idUser, add ? 'addAdmin' : 'unAdmin');

      return add
          ? "Pengguna telah menjadi admin"
          : "Admin telah menjadi pengguna";
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<String> setCounsultant(bool add, String idUser) async {
    try {
      final userCheck = await _userRef.doc(idUser).get();

      if (!userCheck.exists) {
        return "User tidak ada";
      }

      await _userRef.doc(idUser).update({'role': add ? 'counsultant' : 'user'});

      // notifService.createPersonalNotif(idUser, add ? 'addAdmin' : 'unAdmin');

      return add
          ? "Pengguna telah menjadi Counsultant"
          : "Counsultant telah menjadi pengguna";
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<void> updateProfile({
    required String username,
    required String fullname,
    required String email,
    required String bio,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User belum login");

    await _userRef.checkUniqueField(
      field: "username",
      value: username,
      uid: user.uid,
    );

    await _userRef.checkUniqueField(
      field: "email",
      value: email,
      uid: user.uid,
    );

    if (email != user.email) {
      await user.verifyBeforeUpdateEmail(email);
    }
    await _userRef.doc(user.uid).update({
      "fullname": fullname,
      "username": username,
      "bio": bio,
      "email": email,
    });
    print("berhasil");
  }

  Future<void> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser!;
    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: oldPassword,
    );

    await user.reauthenticateWithCredential(cred);
    await user.updatePassword(newPassword);
  }

  Future<String> uploadBase64(File image) async {
    final bytes = await image.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> uploadPhoto({String? photo, String? headerBanner}) async {
    try {
      final uid = _auth.currentUser!.uid;
      final data = <String, dynamic>{};

      if (photo != null) data['photo'] = photo;
      if (headerBanner != null) data['headerBanner'] = headerBanner;

      await _userRef.doc(uid).update(data);
    } catch (e) {
      print("❌ UPLOAD ERROR: $e");
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _auth.signOut();
  }

  Future<void> deleteAccount(String idUser) async {
    try {
      await _userRef.doc(idUser).update({'isActive': false});
      // notifService.createPersonalNotif(idUser, 'deleteAcc');
    } catch (e) {
      print(e);
    }
  }
}
