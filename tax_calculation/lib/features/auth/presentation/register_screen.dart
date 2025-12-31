import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();

  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    // simple email regex (good enough for local auth demo)
    final r = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return r.hasMatch(email);
  }

  Future<void> _register() async {
    setState(() {
      _error = null;
      _loading = true;
    });

    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    final confirm = _confirmCtrl.text;

    // Basic validation
    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      setState(() {
        _error = 'กรุณากรอกข้อมูลให้ครบ';
        _loading = false;
      });
      return;
    }

    if (!_isValidEmail(email)) {
      setState(() {
        _error = 'รูปแบบอีเมลไม่ถูกต้อง';
        _loading = false;
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _error = 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
        _loading = false;
      });
      return;
    }

    if (password != confirm) {
      setState(() {
        _error = 'รหัสผ่านและยืนยันรหัสผ่านไม่ตรงกัน';
        _loading = false;
      });
      return;
    }

    try {
      // Local auth register (ตาม AuthService ที่ทำไว้)
      await ref.read(authServiceProvider).register(email, password);

      // Mark logged-in state
      ref.read(authStateProvider.notifier).state = true;

      if (mounted) {
        // ปิดหน้าสมัคร และกลับไปหน้าเดิม (AuthGate จะพาเข้าแอป)
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _error = 'สมัครสมาชิกไม่สำเร็จ';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สมัครสมาชิก'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'สมัครสมาชิก',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 28),

              // Email
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'อีเมล',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),

              // Password
              TextField(
                controller: _passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'รหัสผ่าน',
                  prefixIcon: Icon(Icons.lock),
                  helperText: 'อย่างน้อย 6 ตัวอักษร',
                ),
              ),
              const SizedBox(height: 16),

              // Confirm Password
              TextField(
                controller: _confirmCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'ยืนยันรหัสผ่าน',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),

              const SizedBox(height: 16),

              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),

              const SizedBox(height: 8),

              ElevatedButton(
                onPressed: _loading ? null : _register,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'สมัครสมาชิก',
                        style: TextStyle(fontSize: 16),
                      ),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: _loading ? null : () => Navigator.pop(context),
                child: const Text('มีบัญชีอยู่แล้ว? กลับไปเข้าสู่ระบบ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
