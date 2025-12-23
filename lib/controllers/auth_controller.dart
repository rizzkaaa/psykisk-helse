import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:uas_project/services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? error;
  File? image;
  bool uploading = false;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    error = await _authService.login(email, password);

    isLoading = false;
    notifyListeners();

    print("INI ERROR: $error\n\n");
    return error == null;
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

  Future<void> uploadPhoto(File img) async {
    uploading = true;
    notifyListeners();

    final url = await _authService.uploadPhoto(img);

    if (url != null) {
      image = img;
    }

    uploading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    isLoading = true;
    notifyListeners();

    await _authService.logout();

    isLoading = false;
    notifyListeners();
  }
}
