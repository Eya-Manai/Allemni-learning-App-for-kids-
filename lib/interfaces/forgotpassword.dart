import 'package:allemni/constants/colors.dart';
import 'package:allemni/widgets/draw_background.dart';
import 'package:allemni/widgets/draw_input_field.dart';
import 'package:allemni/widgets/draw_label.dart';
import 'package:allemni/widgets/draw_title.dart';
import 'package:allemni/widgets/draw_yellow_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final emailController = TextEditingController();
  bool isLoading = false; // Loading state

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.primaryYellow),
      body: Stack(
        children: [
          Buildbackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Center(child: _buildLogo()),
                  Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: BuildTitle("اعادة ضبط كلمة المرور"),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: BuildLabel(
                      'أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور',
                    ),
                  ),
                  const SizedBox(height: 20),
                  BuildInputField(obscure: false, controller: emailController),
                  const SizedBox(height: 30),
                  Center(
                    child: YellowButton(
                      text: "تغيير كلمة المرور",
                      onPressed: _resetPassword,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Image.asset('assets/images/logoapp.png', width: 200, height: 200),
    );
  }

  Future<void> _resetPassword() async {
    if (isLoading) return;

    setState(() => isLoading = true);
    final email = emailController.text.trim();

    if (email.isEmpty || !_isValidEmail(email)) {
      _showDialog('يرجى إدخال بريد إلكتروني صحيح.');
      setState(() => isLoading = false);
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      //ignore:avoid_print
      print("Sending reset to: $email");
      //ignore:avoid_print
      print("Email raw chars: ${emailController.text.runes.toList()}");

      if (!mounted) return;
      _showDialog(
        'تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني. '
        'الرجاء التحقق من صندوق الوارد والمجلد غير المرغوب فيه.',
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      //ignore:avoid_print
      print(e);
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'البريد الإلكتروني غير صالح.';
          break;
        case 'network-request-failed':
          errorMessage = 'الرجاء التحقق من اتصال الإنترنت.';
          break;
        default:
          errorMessage = 'حدث خطأ، يرجى المحاولة لاحقًا.';
      }

      if (!mounted) return;
      _showDialog(errorMessage);
    } catch (e) {
      if (!mounted) return;
      _showDialog('حدث خطأ غير متوقع، يرجى المحاولة لاحقًا.');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(content: Text(message)),
    );
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }
}
