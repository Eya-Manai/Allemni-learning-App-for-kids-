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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginInterface extends StatefulWidget {
  const LoginInterface({super.key});

  @override
  State<LoginInterface> createState() => _LoginInterfaceState();
}

class _LoginInterfaceState extends State<LoginInterface> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  bool _isLoggingIn = false;
  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showToast(message: "الرجاء ادخال البريد الالكتروني و كلمة المرور");
      return;
    }
    setState(() {
      _isLoggingIn = true;
    });
    try {
      final user = await _auth.signInWithEmailAndPassword(email, password);
      setState(() {
        _isLoggingIn = false;
      });
      if (user != null) {
        //ignore: avoid_print
        print("✅ Login success: ${user.uid}");
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.parentHome,
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoggingIn = false;
      });
      //ignore: avoid_print
      print("FirebaseAuthException code: ${e.code}");
      //ignore: avoid_print
      print("FirebaseAuthException message: ${e.message}");
      String errorMsg;
      switch (e.code) {
        case 'invalid-email':
          errorMsg = 'البريد الإلكتروني غير صالح.';
          break;
        case 'user-not-found':
          errorMsg = 'لا يوجد مستخدم بهذا البريد.';
          break;
        case 'wrong-password':
          errorMsg = 'كلمة السر غير صحيحة.';
          break;
        case 'invalid-credential':
          errorMsg = 'بيانات الدخول غير صحيحة.';
          break;
        default:
          errorMsg = 'حدث خطأ: ${e.code}';
      }

      showToast(message: errorMsg);
    }
  }

  Future<void> _signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    setState(() {
      _isLoggingIn = true;
    });
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn
          .signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        await FirebaseAuth.instance.signInWithCredential(authCredential);

        setState(() {
          _isLoggingIn = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoggingIn = false;
      });
      showToast(message: 'فشل تسجيل الدخول باستخدام جوجل: ${e.code}');
    } catch (e) {
      setState(() {
        _isLoggingIn = false;
      });
      showToast(message: "حدث خطأ أثناء تسجيل الدخول باستخدام جوجل.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Buildbackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildLogo(),
                  const SizedBox(height: 20),
                  BuildTitle("تسجيل الدخول"),
                  const SizedBox(height: 30),
                  _buildInputSection(),
                  const SizedBox(height: 20),
                  _buildForgetPasswordLink(),
                  const SizedBox(height: 20),
                  YellowButton(
                    text: 'دخول',
                    onPressed: () {
                      _login();
                    },
                    child: _isLoggingIn
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
                  const SizedBox(height: 20),
                  _buildGoogleSignInButton(_isLoggingIn, _signInWithGoogle),
                  _buildSignUpLink(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
          child: BuildLabel('البريد الإلكتروني'),
        ),
        const SizedBox(height: 10),
        BuildInputField(obscure: false, controller: _emailController),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(right: 24),
          child: BuildLabel('كلمة السر'),
        ),
        const SizedBox(height: 10),
        BuildInputField(obscure: true, controller: _passwordController),
      ],
    );
  }

  Widget _buildGoogleSignInButton(bool isLogginIn, VoidCallback onPressed) {
    return MaterialButton(
      onPressed: isLogginIn ? null : onPressed,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const FaIcon(
            FontAwesomeIcons.google,
            color: AppColors.primaryYellow,
            size: 24,
          ),
          const SizedBox(width: 10),
          const Text(
            'تسجيل الدخول باستخدام جوجل',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'childFont',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Center(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, Routes.signup);
        },
        child: Text(
          'ليس لديك حساب؟',
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

  Widget _buildForgetPasswordLink() {
    return Center(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, Routes.forgetPassword);
        },
        child: Text(
          'نسيت كلمة المرور؟',
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
