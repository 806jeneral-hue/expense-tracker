import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/app_provider.dart';
import '../../../core/constants/app_colors.dart';

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

  @override
  void initState() {
    super.initState();
    _message = widget.isSettingPin ? 'Set your PIN' : 'Enter PIN to unlock';
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

    if (widget.isSettingPin) {
      if (!_isConfirming) {
        // First step of setting PIN
        setState(() {
          _firstPin = _input;
          _input = '';
          _isConfirming = true;
          _message = 'Confirm your PIN';
        });
      } else {
        // Confirming PIN
        if (_input == _firstPin) {
          await provider.setPin(_input);
          if (mounted) Navigator.pop(context);
        } else {
          setState(() {
            _input = '';
            _message = 'PINs do not match. Try again.';
            _isConfirming = false;
            _firstPin = '';
          });
        }
      }
    } else {
      // Unlocking
      if (provider.verifyPin(_input)) {
        if (widget.onUnlocked != null) {
          widget.onUnlocked!();
        } else {
          Navigator.pop(context);
        }
      } else {
        setState(() {
          _input = '';
          _message = 'Incorrect PIN. Try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              // Logo or Icon
              const Icon(Icons.lock_outline_rounded,
                  size: 64, color: Colors.white70),
              const SizedBox(height: 24),
              // Message
              Text(
                _message,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              // PIN Dots
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
              ),
              const Spacer(),
              // Keypad
              _buildKeypad(),
              const SizedBox(height: 48),
            ],
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
              const SizedBox(width: 70), // Spacer
              _buildKey('0'),
              _buildDeleteKey(),
            ],
          ),
        ],
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
        child: const Icon(Icons.backspace_outlined, color: Colors.white70, size: 24),
      ),
    );
  }
}
