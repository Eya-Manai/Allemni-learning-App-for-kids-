import 'package:allemni/constants/colors.dart';
import 'package:allemni/constants/toast.dart';
import 'package:allemni/routes/routes.dart';
import 'package:allemni/widgets/draw_background.dart';
import 'package:allemni/widgets/draw_input_field.dart';
import 'package:allemni/widgets/draw_label.dart';
import 'package:allemni/widgets/draw_title.dart';
import 'package:allemni/widgets/draw_yellow_button.dart';
import 'package:allemni/widgets/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddChildPage extends StatefulWidget {
  const AddChildPage({super.key});

  @override
  State<AddChildPage> createState() => _AddChildPageState();
}

class _AddChildPageState extends State<AddChildPage> {
  final childnameController = TextEditingController();
  final childfamilyNameController = TextEditingController();
  final schoolnameController = TextEditingController();
  bool isadded = false;
  String selectedclass = 'السنة الأولى';
  final List<String> classOptions = [
    'السنة الأولى',
    'السنة الثانية',
    'السنة الثالثة',
    'السنة الرابعة',
    'السنة الخامسة',
    'السنة السادسة',
  ];
  String? selectedAvatar;

  void _addchildinfo() async {
    if (childnameController.text.isEmpty ||
        childfamilyNameController.text.isEmpty ||
        schoolnameController.text.isEmpty ||
        selectedAvatar == null) {
      showToast(message: 'يرجى ملء جميع الحقول');
      return;
    }
    try {
      await FirebaseFirestore.instance.collection('Children').add({
        'first_name': childnameController.text.trim(),
        'last_name': childfamilyNameController.text.trim(),
        'school': schoolnameController.text.trim(),
        'class': selectedclass,
        'avatar': selectedAvatar,
        'created_at': Timestamp.now(),
      });
      setState(() {
        isadded = true;
      });

      showToast(message: "تم اضافة التلميذ بنجاح");

      childnameController.clear();
      childfamilyNameController.clear();
      selectedclass = '';
      selectedAvatar = null;
      setState(() {
        isadded = false;
      });
      if (isadded == false) {
        if (!mounted) return;
        Navigator.pushNamed(context, Routes.parentHome);
      }
    } catch (e) {
      debugPrint(" حدث خطأ أثناء الإضافة $e");
      showToast(message: "حدث خطأ أثناء الإضافة");
    }
  }

  Widget _buildInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 35),
          child: BuildLabel('القسم'),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: classOptions.length,
                itemBuilder: (context, index) {
                  final item = classOptions[index];
                  final isSelected = selectedclass == item;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedclass = item;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryYellow
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: BuildLabel(item),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(right: 35),
          child: BuildLabel('اسم التلميذ '),
        ),
        const SizedBox(height: 10),
        BuildInputField(obscure: false, controller: childnameController),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(right: 35),
          child: BuildLabel('لقب التلميذ'),
        ),
        const SizedBox(height: 10),
        BuildInputField(obscure: false, controller: childfamilyNameController),
        const SizedBox(height: 10),
        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.only(right: 35),
          child: BuildLabel('المدرسة الابتدائية'),
        ),
        const SizedBox(height: 10),
        BuildInputField(obscure: false, controller: schoolnameController),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(right: 35),
          child: BuildLabel('اختر الافتار'),
        ),
        const SizedBox(height: 10),

        Center(
          child: SizedBox(
            height: 160,
            width: 230,
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 16,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(6, (index) {
                final avatarPath = 'assets/images/avatar${index + 1}.png';
                final isSelected = selectedAvatar == avatarPath;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAvatar = avatarPath;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryYellow
                            : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primaryYellow,
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: CircleAvatar(
                      backgroundColor: AppColors.pink,
                      radius: 30,
                      backgroundImage: AssetImage(avatarPath),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Buildbackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 35, top: 35),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: BuildTitle('أضف تلميذ'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildInputSection(),
                  const SizedBox(height: 20),
                  YellowButton(text: "اضافة", onPressed: _addchildinfo),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
