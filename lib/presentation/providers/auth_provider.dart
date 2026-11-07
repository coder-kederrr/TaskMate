import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/dummy/dummy_data.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  bool _isAuthenticated = true; // Set to true by default for demo ease

  UserModel? get user => _user ?? DummyData.currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _user = DummyData.currentUser;
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulated network delay
    await Future.delayed(const Duration(milliseconds: 600));

    _isAuthenticated = true;
    _user = DummyData.currentUser.copyWith(email: email);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String university,
    required String major,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    _isAuthenticated = true;
    _user = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      university: university,
      major: major,
      semester: 1,
    );
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}

