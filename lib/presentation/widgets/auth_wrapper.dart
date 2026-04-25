import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../screens/auth/pin_lock_screen.dart';
import '../screens/main_screen.dart';
import '../screens/splash_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    if (provider.isSecurityEnabled && provider.hasPin && !_isAuthenticated) {
      return PinLockScreen(
        onUnlocked: () => setState(() => _isAuthenticated = true),
      );
    }

    return const SplashScreen();
  }
}
