import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart' as web;
import 'services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;
  bool _gLoading = false;
  bool _obscure = true;
  bool _obscureConfirm = true;
  late AnimationController _animCtrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fade = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _showErr(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: const Color(0xFFE74C3C),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }

  void _showSuccess(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: const Color(0xFF27AE60),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }

  String _errMsg(dynamic e) {
    if (e is AuthException) {
      switch (e.code) {
        case 'email-already-in-use': return 'อีเมลนี้ถูกใช้งานแล้ว';
        case 'weak-password': return 'รหัสผ่านไม่ปลอดภัยเพียงพอ';
        case 'invalid-email': return 'รูปแบบอีเมลไม่ถูกต้อง';
        default: return e.msg;
      }
    }
    return 'เกิดข้อผิดพลาด: $e';
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await _auth.signUpWithEmail(_emailCtrl.text, _passCtrl.text);
      // Sign out immediately so user must login manually
      await _auth.signOut();
      if (mounted) {
        _showSuccess('สมัครสมาชิกสำเร็จ! กรุณาเข้าสู่ระบบ');
        Navigator.pop(context);
      }
    } catch (e) {
      _showErr(_errMsg(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _googleLogin() async {
    setState(() => _gLoading = true);
    try {
      await _auth.signInWithGoogle();
    } catch (e) {
      _showErr(_errMsg(e));
    } finally {
      if (mounted) setState(() => _gLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB2D8D8),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(children: [
                  const SizedBox(height: 32),
                  _topBar(),
                  const SizedBox(height: 24),
                  _logo(),
                  const SizedBox(height: 32),
                  _card(),
                  const SizedBox(height: 20),
                  _googleBtn(),
                  const SizedBox(height: 24),
                  _loginLink(),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBar() => Align(
    alignment: Alignment.centerLeft,
    child: GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 42, height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.45), borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.7)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF3A7CA5), size: 22),
      ),
    ),
  );

  Widget _logo() => Column(children: [
    Container(
      width: 70, height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6), shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.white.withOpacity(0.5), blurRadius: 16, spreadRadius: 2),
          BoxShadow(color: const Color(0xFF7FB5B5).withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 6)),
        ],
      ),
      child: const Center(child: Text('🛒', style: TextStyle(fontSize: 32))),
    ),
    const SizedBox(height: 12),
    const Text('สมัครสมาชิก', style: TextStyle(color: Color(0xFF2A5F6F), fontSize: 24, fontWeight: FontWeight.w800)),
    const SizedBox(height: 4),
    const Text('สร้างบัญชีใหม่เพื่อเริ่มใช้งาน', style: TextStyle(color: Color(0xFF4A8A9A), fontSize: 13)),
  ]);

  Widget _card() => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.55), borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white.withOpacity(0.8)),
      boxShadow: [
        BoxShadow(color: const Color(0xFF7FB5B5).withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8)),
        BoxShadow(color: Colors.white.withOpacity(0.6), blurRadius: 1, offset: const Offset(0, -1)),
      ],
    ),
    child: Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _field(_emailCtrl, 'อีเมล', 'your@email.com', Icons.email_outlined, keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'กรุณากรอกอีเมล';
            if (!RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(v.trim())) return 'รูปแบบอีเมลไม่ถูกต้อง';
            return null;
          }),
        const SizedBox(height: 16),
        _field(_passCtrl, 'รหัสผ่าน', '••••••••', Icons.lock_outline_rounded, obscure: _obscure,
          suffix: IconButton(
            icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFF5BA3B0), size: 20),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'กรุณากรอกรหัสผ่าน';
            if (v.length < 6) return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
            return null;
          }),
        const SizedBox(height: 16),
        _field(_confirmCtrl, 'ยืนยันรหัสผ่าน', '••••••••', Icons.lock_outline_rounded, obscure: _obscureConfirm,
          suffix: IconButton(
            icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFF5BA3B0), size: 20),
            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'กรุณายืนยันรหัสผ่าน';
            if (v != _passCtrl.text) return 'รหัสผ่านไม่ตรงกัน';
            return null;
          }),
        const SizedBox(height: 24),
        SizedBox(height: 50, child: ElevatedButton(
          onPressed: _loading ? null : _signUp,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3A7CA5), foregroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFF3A7CA5).withOpacity(0.6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
          child: _loading
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
              : const Text('สมัครสมาชิก', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        )),
      ]),
    ),
  );

  Widget _field(TextEditingController ctrl, String label, String hint, IconData icon,
      {TextInputType? keyboardType, bool obscure = false, Widget? suffix, String? Function(String?)? validator}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: Color(0xFF2A5F6F), fontSize: 13, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      TextFormField(
        controller: ctrl, keyboardType: keyboardType, obscureText: obscure, validator: validator,
        style: const TextStyle(color: Color(0xFF2A5F6F), fontSize: 15),
        decoration: InputDecoration(
          hintText: hint, hintStyle: TextStyle(color: const Color(0xFF5BA3B0).withOpacity(0.5), fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFF5BA3B0), size: 20), suffixIcon: suffix,
          filled: true, fillColor: Colors.white.withOpacity(0.6),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withOpacity(0.8))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withOpacity(0.8))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF3A7CA5), width: 1.5)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE74C3C))),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE74C3C), width: 1.5)),
        ),
      ),
    ]);
  }

  Widget _googleBtn() {
    if (kIsWeb) {
      final webPlugin = GoogleSignInPlatform.instance as web.GoogleSignInPlugin;
      return SizedBox(
        height: 50,
        child: webPlugin.renderButton(
          configuration: web.GSIButtonConfiguration(
            type: web.GSIButtonType.standard,
            theme: web.GSIButtonTheme.outline,
            size: web.GSIButtonSize.large,
            text: web.GSIButtonText.signin,
            shape: web.GSIButtonShape.pill,
            logoAlignment: web.GSIButtonLogoAlignment.center,
            minimumWidth: 320,
          ),
        ),
      );
    }
    return SizedBox(height: 50, child: OutlinedButton(
      onPressed: _gLoading ? null : _googleLogin,
      style: OutlinedButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.7),
        side: BorderSide(color: Colors.white.withOpacity(0.9)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
      child: _gLoading
          ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Color(0xFF3A7CA5), strokeWidth: 2.5))
          : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.g_mobiledata, color: Color(0xFF4285F4), size: 28),
              SizedBox(width: 8),
              Text('สมัครด้วย Google', style: TextStyle(color: Color(0xFF2A5F6F), fontSize: 15, fontWeight: FontWeight.w600)),
            ]),
    ));
  }

  Widget _loginLink() => Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    const Text('มีบัญชีอยู่แล้ว? ', style: TextStyle(color: Color(0xFF4A8A9A), fontSize: 14)),
    GestureDetector(
      onTap: () => Navigator.pop(context),
      child: const Text('เข้าสู่ระบบ', style: TextStyle(color: Color(0xFF3A7CA5), fontSize: 14, fontWeight: FontWeight.w700)),
    ),
  ]);
}
