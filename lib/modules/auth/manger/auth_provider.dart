import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/routes/app_route_name.dart';
import '../../../core/service/toast.dart';
import '../../../main.dart';
import '../models/user_model.dart';
import '../services/firebase_services.dart';

class AuthProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String selectedAvatar = 'assets/images/gamer (2).png';
  bool _isLoading = false;
  UserModel? currentUser;

  bool get isLoading => _isLoading;
  bool get isLoding => _isLoading; // Compatibility alias

  void updateAvatar(String avatar) {
    selectedAvatar = avatar;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> createAccount({BuildContext? context}) async {
    final String enteredName = nameController.text.trim();
    if (enteredName.isEmpty) {
      Toast.show(title: "Please enter your name", type: ToastType.error);
      return;
    }

    _setLoading(true);
    try {
      final credential = await FirebaseServices.createAccount(
        password: passwordController.text,
        name: enteredName,
        email: emailController.text.trim(),
        avatar: selectedAvatar,
      );

      credential?.user?.sendEmailVerification().catchError((_) {});

      Toast.show(title: "Welcome, $enteredName!", type: ToastType.success);

      nameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

      if (context != null && context.mounted) {
        Navigator.pushReplacementNamed(context, AppRouteName.loginScreen);
      } else if (navigatorKey.currentState != null) {
        navigatorKey.currentState!.pushReplacementNamed(
          AppRouteName.loginScreen,
        );
      }
    } catch (e) {
      Toast.show(title: e.toString(), type: ToastType.error);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> login() async {
    _setLoading(true);
    try {
      final credential = await FirebaseServices.login(
        password: passwordController.text,
        email: emailController.text.trim(),
      );

      if (credential?.user != null) {
        if (credential!.user!.emailVerified) {
          navigatorKey.currentState?.pushReplacementNamed(AppRouteName.  homeScreen2);

          currentUser = await FirebaseServices.getUser(credential.user!.uid);
          final displayName =
              currentUser?.name ?? credential.user!.displayName ?? 'User';
          Toast.show(
            title: "Welcome back, $displayName!",
            type: ToastType.success,
          );
        } else {
          Toast.show(
            title: "Please verify your email first.",
            type: ToastType.error,
          );
        }
      }
    } catch (e) {
      Toast.show(title: e.toString(), type: ToastType.error);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetPassword() async {
    if (emailController.text.trim().isEmpty) {
      Toast.show(
        title: "Please enter your email address.",
        type: ToastType.error,
      );
      return;
    }

    try {
      await FirebaseServices.resetPassword(email: emailController.text.trim());
      Toast.show(
        title: "Password reset link sent! Check your inbox.",
        type: ToastType.success,
      );
    } catch (e) {
      Toast.show(title: e.toString(), type: ToastType.error);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithGoogle() async {
    _setLoading(true);
    try {
      final credential = await FirebaseServices.signInWithGoogle();
      if (credential?.user != null) {
        navigatorKey.currentState?.pushReplacementNamed(AppRouteName.homeScreen2);
        currentUser = await FirebaseServices.getUser(credential!.user!.uid);
        final displayName =
            currentUser?.name ?? credential.user!.displayName ?? 'User';
        Toast.show(title: "Welcome, $displayName!", type: ToastType.success);
      }
    } catch (e) {
      Toast.show(title: e.toString(), type: ToastType.error);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sinInWhithGoogle() => signInWithGoogle();

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
