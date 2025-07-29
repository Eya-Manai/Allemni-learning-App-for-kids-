import 'package:allemni/constants/colors.dart';
import 'package:flutter/material.dart';

class BildOptionBox extends StatelessWidget {
  final String label;
  final String image;
  final Color color;
  final bool locked;
  final VoidCallback? ontap;

  const BildOptionBox({
    super.key,
    required this.label,
    required this.image,
    required this.color,
    required this.locked,
    required this.ontap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: 120,
        height: 140,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 5,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(image, height: 60),
                  const SizedBox(height: 10),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'childFont',
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
            if (locked)
              Positioned(
                right: 10,
                bottom: 5,
                child: Image.asset(
                  "assets/images/lock.png",
                  width: 22,
                  height: 22,
                  fit: BoxFit.contain,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
