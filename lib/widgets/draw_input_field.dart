import 'package:allemni/constants/colors.dart';
import 'package:flutter/material.dart';

class BuildInputField extends StatelessWidget {
  final bool obscure;
  final TextEditingController controller;

  const BuildInputField({
    super.key,
    required this.obscure,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fieldWidth = screenWidth * 0.85;
    final double fieldHeight = screenWidth * 0.12;

    return Center(
      child: Container(
        width: fieldWidth,
        height: fieldHeight,
        decoration: BoxDecoration(
          color: AppColors.lightYellow,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.gray,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          textAlign: TextAlign.right,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          ),
        ),
      ),
    );
  }
}
