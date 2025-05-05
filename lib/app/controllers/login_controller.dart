import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventoryplatform/app/routes/app_routes.dart';
import 'package:inventoryplatform/app/services/auth_service.dart';
import 'package:inventoryplatform/app/services/error_service.dart';
import 'package:inventoryplatform/app/ui/device/theme/credentials_model.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final ErrorService _errorService = Get.find<ErrorService>();

  Future<bool> handleGoogleSignIn() async {
    try {
      final success = await _authService.signInWithGoogle();
      if (success) {
        Get.offAllNamed(Routes.HOME);
      }
      return success;
    } catch (e) {
      _errorService.handleError(e as Exception);
      return false;
    }
  }

  Future<bool> handleSignIn(UserCredentialsModel credentials) async {
    try {
      final success = await _authService.signInWithEmailPassword(
          credentials.email, credentials.password!);
      if (success) {
        Get.offAllNamed(Routes.HOME);
      }
      return success;
    } catch (e) {
      _errorService.handleError(e as Exception);
      return false;
    }
  }

  Future<void> checkLoginStatus(BuildContext context) async {
    debugPrint('Checking login status...');
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(Routes.HOME);
      });
    }
  }
}
