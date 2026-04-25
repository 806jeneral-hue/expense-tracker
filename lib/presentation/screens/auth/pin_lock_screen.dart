import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/app_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/premium_logo.dart';

class PinLockScreen extends StatefulWidget {
  final bool isSettingPin;
  final VoidCallback? onUnlocked;

  const PinLockScreen({
    super.key,
    this.isSettingPin = false,
    this.onUnlocked,
  });

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  String _input = '';
  String _firstPin = '';
  bool _isConfirming = false;
  bool _obscureText = true;
  String _message = '';
  final TextEditingController _passController = TextEditingController();
  final FocusNode _passFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    final provider = context.read<AppProvider>();
    _initMessage(provider);
    
    if (!widget.isSettingPin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkAndAuthenticate();
        if (provider.securityType == 'password') {
          _passFocus.requestFocus();
        }
      });
    } else if (provider.securityType == 'password') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _passFocus.requestFocus();
      });
    }
  }

  void _initMessage(AppProvider provider) {
    if (widget.isSettingPin) {
      _message = provider.securityType == 'pin'
          ? (provider.isArabic ? 'عيّن الرقم السري' : 'Set your PIN')
          : (provider.isArabic ? 'عيّن كلمة المرور' : 'Set your Password');
    } else {
      _message = provider.securityType == 'pin'
          ? (provider.isArabic ? 'أدخل الرقم السري لفتح التطبيق' : 'Enter PIN to unlock')
          : (provider.isArabic ? 'أدخل كلمة المرور لفتح التطبيق' : 'Enter Password to unlock');
    }
  }

  Future<void> _checkAndAuthenticate() async {
    final provider = context.read<AppProvider>();
    await provider.checkBiometrics();
    if (provider.isBiometricAvailable) {
      final success = await provider.authenticateWithBiometrics();
      if (success && mounted) {
        if (widget.onUnlocked != null) {
          widget.onUnlocked!();
        } else {
          Navigator.pop(context);
        }
      }
    }
  }

  void _onNumberPressed(String number) {
    if (_input.length < 4) {
      setState(() {
        _input += number;
        if (_input.length == 4) {
          _handleComplete();
        }
      });
    }
  }

  void _onDelete() {
    if (_input.isNotEmpty) {
      setState(() => _input = _input.substring(0, _input.length - 1));
    }
  }

  Future<void> _handleComplete() async {
    final provider = context.read<AppProvider>();
    final isPin = provider.securityType == 'pin';

    if (widget.isSettingPin) {
      if (!_isConfirming) {
        setState(() {
          _firstPin = _input;
          _input = '';
          _passController.clear();
          _isConfirming = true;
          _message = isPin
              ? (provider.isArabic ? 'تأكيد الرقم السري' : 'Confirm your PIN')
              : (provider.isArabic ? 'تأكيد كلمة المرور' : 'Confirm your Password');
        });
        if (!isPin) _passFocus.requestFocus();
      } else {
        if (_input == _firstPin) {
          await provider.setPin(_input);
          if (mounted) Navigator.pop(context);
        } else {
          setState(() {
            _input = '';
            _passController.clear();
            _message = provider.isArabic
                ? 'غير متطابق، حاول ثانية'
                : 'Does not match. Try again.';
            _isConfirming = false;
            _firstPin = '';
          });
          if (!isPin) _passFocus.requestFocus();
        }
      }
    } else {
      if (provider.verifyPin(_input)) {
        if (widget.onUnlocked != null) {
          widget.onUnlocked!();
        } else {
          Navigator.pop(context);
        }
      } else {
        setState(() {
          _input = '';
          _passController.clear();
          _message = provider.isArabic
              ? 'كلمة المرور خاطئة، حاول ثانية'
              : 'Incorrect. Try again.';
        });
        if (!isPin) _passFocus.requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isPin = provider.securityType == 'pin';

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const PremiumLogo(size: 80),
                  const SizedBox(height: 32),
                  Text(
                    _message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  if (isPin)
                    _buildPinDots()
                  else
                    _buildPasswordField(provider),

                  const SizedBox(height: 48),
                  
                  if (isPin)
                    _buildKeypad()
                  else
                    _buildUnlockButton(provider),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        bool filled = index < _input.length;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? Colors.white : Colors.white24,
            border: Border.all(color: Colors.white38, width: 2),
            boxShadow: filled ? [
              BoxShadow(color: Colors.white.withOpacity(0.3), blurRadius: 8, spreadRadius: 1)
            ] : [],
          ),
        );
      }),
    );
  }

  Widget _buildPasswordField(AppProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: _passController,
        focusNode: _passFocus,
        obscureText: _obscureText,
        style: GoogleFonts.outfit(color: Colors.white, fontSize: 18),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: provider.isArabic ? 'أدخل كلمة المرور' : 'Enter Password',
          hintStyle: const TextStyle(color: Colors.white38),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white24, width: 2)),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2)),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.white70,
            ),
            onPressed: () => setState(() => _obscureText = !_obscureText),
          ),
        ),
        onChanged: (v) => _input = v,
        onSubmitted: (_) => _handleComplete(),
      ),
    );
  }

  Widget _buildUnlockButton(AppProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        onPressed: _handleComplete,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
        ),
        child: Text(
          widget.isSettingPin
              ? (provider.isArabic ? 'حفظ وإكمال' : 'Save & Continue')
              : (provider.isArabic ? 'فتح التطبيق' : 'Unlock App'),
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          for (var row in [['1', '2', '3'], ['4', '5', '6'], ['7', '8', '9']]) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: row.map((n) => _buildKey(n)).toList(),
            ),
            const SizedBox(height: 20),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!widget.isSettingPin) _buildBiometricKey() else const SizedBox(width: 75),
              _buildKey('0'),
              _buildDeleteKey(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String number) {
    return InkWell(
      onTap: () => _onNumberPressed(number),
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 75,
        height: 75,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1),
        ),
        alignment: Alignment.center,
        child: Text(
          number,
          style: GoogleFonts.outfit(fontSize: 32, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildBiometricKey() {
    return InkWell(
      onTap: _checkAndAuthenticate,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 75,
        height: 75,
        alignment: Alignment.center,
        child: const Icon(Icons.fingerprint_rounded, color: Colors.white70, size: 40),
      ),
    );
  }

  Widget _buildDeleteKey() {
    return InkWell(
      onTap: _onDelete,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 75,
        height: 75,
        alignment: Alignment.center,
        child: const Icon(Icons.backspace_outlined, color: Colors.white70, size: 28),
      ),
    );
  }
}

