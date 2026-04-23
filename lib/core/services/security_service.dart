import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class SecurityService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> canCheckBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> authenticate() async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'يرجى تأكيد هويتك لفتح التطبيق',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false, // يسمح بالبصمة أو الـ PIN
        ),
      );
      return didAuthenticate;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }
}
