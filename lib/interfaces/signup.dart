import 'package:allemni/constants/colors.dart';
import 'package:allemni/constants/toast.dart';
import 'package:allemni/routes/routes.dart';
import 'package:allemni/services/firebase_auth_services.dart';
import 'package:allemni/widgets/draw_background.dart';
import 'package:allemni/widgets/draw_input_field.dart';
import 'package:allemni/widgets/draw_title.dart';
import 'package:allemni/widgets/draw_label.dart';
import 'package:allemni/widgets/draw_yellow_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _nameFamilyNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  bool _isSigningUp = false;

  @override
  void dispose() {
    _nameFamilyNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    // String nameFamilyName = _nameFamilyNameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showToast(message: "يرجى ملء جميع الحقول");
      return;
    }

    if (password.length < 8) {
      showToast(message: "كلمة المرور يجب أن تحتوي على 8 أحرف على الأقل");
      return;
    }
    setState(() {
      _isSigningUp = true;
    });

    try {
      User? user = await _auth.signUpWithEmailAndPassword(email, password);
      if (!mounted) return;

      setState(() {
        _isSigningUp = false;
      });

      if (user != null) {
        setState(() {
          _isSigningUp = false;
        });
        // await user.updateProfile(displayName: nameFamilyName);
        //await user.reload();
        //ignore: avoid_print
        print("user created successfully: ${user.uid}");
        Navigator.pushNamed(context, Routes.parentHome);
      } else {
        //ignore: avoid_print
        showToast(message: "حدث خطأ أثناء إنشاء الحساب.");
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isSigningUp = false;
      });

      String errormessage;

      switch (e.code) {
        case 'email-already-in-use':
          errormessage = 'البريد الإلكتروني مستعمل من قبل.';
          break;

        case 'invalid-email':
          errormessage = 'البريد الإلكتروني غير صالح.';
          break;

        case 'weak-password':
          errormessage = 'كلمة المرور ضعيفة جداً.';
          break;
        default:
          errormessage = 'حدث خطأ: ${e.code}';
      }
      showToast(message: errormessage);
    } catch (e) {
      setState(() {
        _isSigningUp = false;
      });
      showToast(message: "حدث خطأ غير متوقع أثناء إنشاء الحساب.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Buildbackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  _buildLogo(),
                  const SizedBox(height: 5),
                  BuildTitle("إنشاء حساب"),
                  const SizedBox(height: 20),
                  _buildInputSection(),
                  const SizedBox(height: 40),
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

  Widget _buildInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 24),
          child: BuildLabel('الاسم '),
        ),
        const SizedBox(height: 10),
        BuildInputField(obscure: false, controller: _nameFamilyNameController),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(right: 24),
          child: BuildLabel('اللقب '),
        ),
        const SizedBox(height: 10),

        BuildInputField(obscure: false, controller: _nameFamilyNameController),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(right: 24),
          child: BuildLabel('البريد الإلكتروني'),
        ),
        const SizedBox(height: 10),
        BuildInputField(obscure: false, controller: _emailController),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(right: 24),
          child: BuildLabel('كلمة المرور'),
        ),
        const SizedBox(height: 10),
        BuildInputField(obscure: true, controller: _passwordController),
        const SizedBox(height: 20),
        Center(
          child: YellowButton(
            text: 'إنشاء حساب',
            onPressed: _signUp,
            child: _isSigningUp
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2,
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 20),
        _buildSignInLink(),
      ],
    );
  }

  Widget _buildSignInLink() {
    return Center(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, Routes.login);
        },
        child: Text(
          'لديك حساب بالفعل؟',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'childFont',

            color: AppColors.darkGreen,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.darkGreen,
          ),
        ),
      ),
    );
  }
}
