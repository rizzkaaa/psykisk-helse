import 'dart:io';
import 'dart:convert';
import 'package:uas_project/models/users_model.dart';
import 'package:flutter/material.dart';
import 'package:uas_project/services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? error;
  UserModel? user;

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

  Future<UserModel> getProfile() async {
    try {
      final user = await _authService.getProfile();
      return user;
    } catch (e) {
      throw Exception('Gagal mengambil profile');
    }
  }

  ImageProvider getImageProvider(String? photo) {
    if (photo == null || photo.toString().isEmpty) {
      return const AssetImage('assets/images/default-profile.png');
    }

    final photoStr = photo.toString();

    try {
      return MemoryImage(base64Decode(photoStr));
    } catch (e) {
      return AssetImage('assets/images/default-profile.png');
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

  Future<void> logout() async {
    isLoading = true;
    notifyListeners();

    await _authService.logout();

    isLoading = false;
    notifyListeners();
  }
}
