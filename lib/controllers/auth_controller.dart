import 'dart:io';
import 'package:uas_project/models/users_model.dart';
import 'package:flutter/material.dart';
import 'package:uas_project/services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? error;
  UserModel? userData;

  Future<void> loadUser({bool force = false}) async {
    if ((userData != null && !force) || isLoading) return;
    if (isLoading) return;

    isLoading = true;
    // notifyListeners();

    try {
      userData = await _authService.getProfile();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      error = await _authService.login(email, password);
      return error == null;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String username, String email, String password) async {
    isLoading = true;
    notifyListeners();

    error = await _authService.register(username, email, password);

    isLoading = false;
    notifyListeners();

    print("INI ERROR: $error\n\n");
    return error == null;
  }

  Future<List<UserModel>> fetchAllUser() async {
    try {
      isLoading = true;
      notifyListeners();

      final users = await _authService.getAllUsers();

      isLoading = false;
      notifyListeners();
      return users;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception('Gagal mengambil data');
    }
  }

  Future<UserModel> getProfile() async {
    try {
      isLoading = true;
      notifyListeners();

      final user = await _authService.getProfile();

      isLoading = false;
      notifyListeners();
      return user;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception('Gagal mengambil profile');
    }
  }

  Future<List<UserModel>> fetchConsultant() async {
    try {
      isLoading = true;
      notifyListeners();

      final counsultant = await _authService.getConsultant();

      isLoading = false;
      notifyListeners();
      return counsultant;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception('Gagal mengambil data');
    }
  }

  Future<UserModel?> fetchUserByID(String idUser) async {
    isLoading = true;
    notifyListeners();

    try {
      final user = await _authService.getUserByID(idUser);
      isLoading = false;
      notifyListeners();
      return user;
    } catch (e) {
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    required String username,
    required String fullname,
    required String bio,
    required String email,
    File? photo,
    File? headerBanner,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      await _authService.updateProfile(
        username: username,
        fullname: fullname,
        email: email,
        bio: bio,
      );

      if (photo != null || headerBanner != null) {
        final photoConvert = photo != null
            ? await _authService.uploadBase64(photo)
            : null;

        final headerBannerConvert = headerBanner != null
            ? await _authService.uploadBase64(headerBanner)
            : null;

        await _authService.uploadPhoto(
          photo: photoConvert,
          headerBanner: headerBannerConvert,
        );
      }
    } catch (e) {
      print('UPDATE PROFILE ERROR: $e');

      // debugPrintStack(stackTrace: s);
      rethrow; // ⬅️ supaya UI bisa nangkap error
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePassword(String oldPassword, String newPassword) async {
    isLoading = true;
    notifyListeners();
    try {
      await _authService.updatePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      print('UPDATE PROFILE ERROR: $e');
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<UserModel>> searchUser(String query) async {
    try {
      isLoading = true;
      notifyListeners();

      final users = await _authService.searchUser(query);

      isLoading = false;
      notifyListeners();
      return users;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception('Gagal mengambil data');
    }
  }

  Future<String> setAdmin(bool add, String idUser) async {
    try {
      isLoading = true;
      notifyListeners();

      final message = await _authService.setAdmin(add, idUser);

      isLoading = false;
      notifyListeners();
      return message;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception('Failed set');
    }
  }

  Future<void> logout() async {
    isLoading = true;
    notifyListeners();

    await _authService.logout();
    userData = null;

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteAcc(String idUser) async {
    try {
      isLoading = true;
      notifyListeners();

      await _authService.deleteAccount(idUser);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception('Failed set');
    }
  }
}
