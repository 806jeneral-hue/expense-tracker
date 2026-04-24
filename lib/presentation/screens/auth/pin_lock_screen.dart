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
  String _message = '';
  final TextEditingController _passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = context.read<AppProvider>();
    if (widget.isSettingPin) {
      _message = provider.securityType == 'pin'
          ? (provider.isArabic ? 'عيّن الرقم السري' : 'Set your PIN')
          : (provider.isArabic ? 'عيّن كلمة المرور' : 'Set your Password');
    } else {
      _message = provider.securityType == 'pin'
          ? (provider.isArabic ? 'أدخل الرقم السري' : 'Enter PIN to unlock')
          : (provider.isArabic ? 'أدخل كلمة المرور' : 'Enter Password to unlock');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkAndAuthenticate();
      });
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
    if (_input.length < 8) {
      // Allow up to 8 for PIN if needed, but usually 4
      setState(() {
        _input += number;
        if (context.read<AppProvider>().securityType == 'pin' &&
            _input.length == 4) {
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
              : (provider.isArabic
                  ? 'تأكيد كلمة المرور'
                  : 'Confirm your Password');
        });
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
              ? 'خطأ، حاول ثانية'
              : 'Incorrect. Try again.';
        });
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  const Spacer(),
                  const PremiumLogo(size: 80),
                  const SizedBox(height: 24),
                  Text(
                    _message,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (isPin)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        bool filled = index < _input.length;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: filled ? Colors.white : Colors.white24,
                            border: Border.all(color: Colors.white38),
                          ),
                        );
                      }),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextField(
                        controller: _passController,
                        obscureText: true,
                        style: GoogleFonts.outfit(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: provider.isArabic ? 'كلمة المرور' : 'Password',
                          hintStyle: const TextStyle(color: Colors.white38),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white24)),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                        ),
                        onChanged: (v) => _input = v,
                        onSubmitted: (_) => _handleComplete(),
                      ),
                    ),
                  const Spacer(),
                  if (isPin)
                    _buildKeypad()
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: ElevatedButton(
                        onPressed: _handleComplete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          widget.isSettingPin
                              ? (provider.isArabic ? 'حفظ' : 'Save')
                              : (provider.isArabic ? 'فتح' : 'Unlock'),
                          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          for (var row in [
            ['1', '2', '3'],
            ['4', '5', '6'],
            ['7', '8', '9'],
          ]) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: row.map((n) => _buildKey(n)).toList(),
            ),
            const SizedBox(height: 20),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!widget.isSettingPin)
                _buildBiometricKey()
              else
                const SizedBox(width: 70),
              _buildKey('0'),
              _buildDeleteKey(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBiometricKey() {
    return GestureDetector(
      onTap: _checkAndAuthenticate,
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        child: const Icon(Icons.fingerprint_rounded,
            color: Colors.white70, size: 32),
      ),
    );
  }

  Widget _buildKey(String number) {
    return GestureDetector(
      onTap: () => _onNumberPressed(number),
      child: Container(
        width: 70,
        height: 70,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white10,
        ),
        alignment: Alignment.center,
        child: Text(
          number,
          style: GoogleFonts.outfit(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteKey() {
    return GestureDetector(
      onTap: _onDelete,
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        child:
            const Icon(Icons.backspace_outlined, color: Colors.white70, size: 24),
      ),
    );
  }
}
