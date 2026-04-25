import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/app_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/premium_logo.dart';

class PinLockScreen extends StatefulWidget {
  final VoidCallback? onUnlocked;

  const PinLockScreen({
    super.key,
    this.onUnlocked,
  });

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authenticate();
    });
  }

  Future<void> _authenticate() async {
    final provider = context.read<AppProvider>();
    final success = await provider.authenticateWithBiometrics();
    if (success && mounted) {
      if (widget.onUnlocked != null) {
        widget.onUnlocked!();
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.darkBackground, AppColors.primary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PremiumLogo(size: 100),
              const SizedBox(height: 48),
              Text(
                provider.isArabic ? 'التطبيق مقفل' : 'App is Locked',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                provider.isArabic 
                    ? 'استخدم حماية الهاتف للفتح' 
                    : 'Use device security to unlock',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: ElevatedButton.icon(
                  onPressed: _authenticate,
                  icon: const Icon(Icons.fingerprint_rounded, size: 28),
                  label: Text(
                    provider.isArabic ? 'فتح الآن' : 'Unlock Now',
                    style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


