import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;
  bool _sent = false;
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

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await _auth.resetPassword(_emailCtrl.text);
      setState(() => _sent = true);
    } catch (e) {
      _showErr('เกิดข้อผิดพลาด กรุณาตรวจสอบอีเมลแล้วลองใหม่');
    } finally {
      if (mounted) setState(() => _loading = false);
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
                  const SizedBox(height: 48),
                  _icon(),
                  const SizedBox(height: 36),
                  _sent ? _successCard() : _formCard(),
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

  Widget _icon() => Column(children: [
    Container(
      width: 80, height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6), shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.white.withOpacity(0.5), blurRadius: 16, spreadRadius: 2),
          BoxShadow(color: const Color(0xFF7FB5B5).withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 6)),
        ],
      ),
      child: Icon(_sent ? Icons.mark_email_read_outlined : Icons.lock_reset_rounded, color: const Color(0xFF3A7CA5), size: 38),
    ),
    const SizedBox(height: 16),
    Text(_sent ? 'ส่งอีเมลแล้ว!' : 'ลืมรหัสผ่าน',
        style: const TextStyle(color: Color(0xFF2A5F6F), fontSize: 24, fontWeight: FontWeight.w800)),
    const SizedBox(height: 6),
    Text(_sent ? 'กรุณาตรวจสอบกล่องจดหมายของคุณ' : 'กรอกอีเมลเพื่อรับลิงก์รีเซ็ตรหัสผ่าน',
        style: const TextStyle(color: Color(0xFF4A8A9A), fontSize: 13), textAlign: TextAlign.center),
  ]);

  Widget _formCard() => Container(
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
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('อีเมล', style: TextStyle(color: Color(0xFF2A5F6F), fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailCtrl, keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Color(0xFF2A5F6F), fontSize: 15),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'กรุณากรอกอีเมล';
              if (!RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(v.trim())) return 'รูปแบบอีเมลไม่ถูกต้อง';
              return null;
            },
            decoration: InputDecoration(
              hintText: 'your@email.com',
              hintStyle: TextStyle(color: const Color(0xFF5BA3B0).withOpacity(0.5), fontSize: 14),
              prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF5BA3B0), size: 20),
              filled: true, fillColor: Colors.white.withOpacity(0.6),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withOpacity(0.8))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withOpacity(0.8))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF3A7CA5), width: 1.5)),
              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE74C3C))),
              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE74C3C), width: 1.5)),
            ),
          ),
        ]),
        const SizedBox(height: 24),
        SizedBox(height: 50, child: ElevatedButton(
          onPressed: _loading ? null : _resetPassword,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3A7CA5), foregroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFF3A7CA5).withOpacity(0.6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
          child: _loading
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
              : const Text('ส่งลิงก์รีเซ็ตรหัสผ่าน', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        )),
      ]),
    ),
  );

  Widget _successCard() => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.55), borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white.withOpacity(0.8)),
      boxShadow: [
        BoxShadow(color: const Color(0xFF7FB5B5).withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8)),
      ],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const Text(
        'เราได้ส่งลิงก์สำหรับรีเซ็ตรหัสผ่านไปยังอีเมลของคุณแล้ว กรุณาตรวจสอบกล่องจดหมายและทำตามคำแนะนำ',
        style: TextStyle(color: Color(0xFF2A5F6F), fontSize: 14, height: 1.5),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 24),
      SizedBox(height: 50, child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3A7CA5), foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
        child: const Text('กลับไปหน้าเข้าสู่ระบบ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      )),
    ]),
  );
}
