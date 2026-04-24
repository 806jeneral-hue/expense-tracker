import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PremiumLogo extends StatelessWidget {
  final double size;
  final bool useDarkTheme;

  const PremiumLogo({
    super.key,
    this.size = 100,
    this.useDarkTheme = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: useDarkTheme ? AppColors.darkSurface : AppColors.primary,
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background subtle pattern
          Positioned(
            top: -size * 0.2,
            right: -size * 0.2,
            child: Container(
              width: size * 0.6,
              height: size * 0.6,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // Main Icon (Wallet + Coin)
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.secondary, AppColors.secondaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              size: size * 0.5,
              color: Colors.white,
            ),
          ),
          
          // Small Floating Coin
          Positioned(
            top: size * 0.2,
            right: size * 0.22,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.attach_money_rounded,
                size: size * 0.18,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
