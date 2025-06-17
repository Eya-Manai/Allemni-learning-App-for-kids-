import 'package:allemni/constants/colors.dart';
import 'package:flutter/material.dart';

class BuildInputField extends StatelessWidget {
  final bool obscure;

  const BuildInputField({super.key, required this.obscure});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fieldWidth = screenWidth * 0.85;

    return Center(
      child: Container(
        width: fieldWidth,
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
