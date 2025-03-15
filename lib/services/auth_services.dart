import 'package:flutter/material.dart';

class AuthService {
  static String userRole = ""; // 'admin' or 'user'

  static Future<bool> login(String email, String password) async {
    if (email == "admin@example.com" && password == "admin123") {
      userRole = "admin";
      return true;
    } else if (email == "user@example.com" && password == "user123") {
      userRole = "user";
      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    userRole = ""; // Clear the user role
  }
}
