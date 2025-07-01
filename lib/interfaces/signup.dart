import 'package:allemni/constants/colors.dart';
import 'package:allemni/constants/toast.dart';
import 'package:allemni/routes/routes.dart';
import 'package:allemni/services/firebase_auth_services.dart';
import 'package:allemni/widgets/draw_background.dart';
import 'package:allemni/widgets/draw_input_field.dart';
import 'package:allemni/widgets/draw_title.dart';
import 'package:allemni/widgets/draw_label.dart';
import 'package:allemni/widgets/draw_yellow_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _firstNameController = TextEditingController();
  final _familyNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  bool _isSigningUp = false;
  String? _selectedGender;
  final List<String> _genders = ['ذكر', 'أنثى'];

  @override
  void dispose() {
    _firstNameController.dispose();
    _familyNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    // String nameFamilyName = _nameFamilyNameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String phone = _phoneNumberController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showToast(message: "يرجى ملء جميع الحقول");
      return;
    }

    if (password.length < 8) {
      showToast(message: "كلمة المرور يجب أن تحتوي على 8 أحرف على الأقل");
      return;
    }
    if (phone.isEmpty) {
      showToast(message: "يرجى إدخال رقم الهاتف");
      return;
    }

    if (!_isValidPoneNumber(phone)) {
      showToast(message: ".رقم الهاتف غير صالح");
      return;
    }
    setState(() {
      _isSigningUp = true;
    });

    if (_selectedGender == null) {
      showToast(message: "رجى اختيار الجنس");
      return;
    }

    try {
      User? user = await _auth.signUpWithEmailAndPassword(email, password);
      if (!mounted) return;

      setState(() {
        _isSigningUp = false;
      });

      if (user != null && user.uid.isNotEmpty) {
        setState(() {
          _isSigningUp = false;
        });
        _addUserDetails(
          user.uid,
          _firstNameController.text.trim(),
          _familyNameController.text.trim(),
          _emailController.text.trim(),
          _phoneNumberController.text.trim(),
        );
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

  Future<void> _addUserDetails(
    String uid,
    String firstname,
    String familyname,
    String email,
    String phone,
  ) async {
    try {
      await FirebaseFirestore.instance.collection("Users").doc(uid).set({
        "first_name": firstname,
        "family_name": familyname,
        "email": email,
        "phone_number": phone,
        "gender": _selectedGender,
      });
      //ignore: avoid_print
      print("✅ Données utilisateur enregistrées !");
    } catch (e) {
      //ignore: avoid_print
      print("❌ Erreur Firestore: $e");
      showToast(message: "فشل في حفظ معلومات المستخدم.");
    }
  }

  bool _isValidPoneNumber(String phone) {
    final regex = RegExp(r'^[245793]\d{7}$');
    return regex.hasMatch(phone);
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
        BuildInputField(obscure: false, controller: _firstNameController),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(right: 24),
          child: BuildLabel('اللقب '),
        ),
        const SizedBox(height: 10),

        BuildInputField(obscure: false, controller: _familyNameController),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(right: 24),
          child: BuildLabel('الجنس'),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.lightYellow,
            ),
            child: DropdownButtonHideUnderline(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: DropdownButton<String>(
                  value: _selectedGender,
                  hint: const Text('اختر الجنس'),
                  icon: const Icon(Icons.arrow_drop_down),
                  isExpanded: true,
                  items: _genders.map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(gender),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(right: 24),
          child: BuildLabel('رقم الهاتف '),
        ),
        const SizedBox(height: 10),

        BuildInputField(obscure: false, controller: _phoneNumberController),
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
