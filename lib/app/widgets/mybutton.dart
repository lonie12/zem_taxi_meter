import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String title;
  final Color color;
  final IconData? icon;
  final double size;
  final double width;
  final VoidCallback onClick;
  final double borderRadius;

  const MyButton({
    required this.title,
    required this.color,
    this.icon,
    this.size = 24.0,
    this.width = 120.0,
    required this.onClick,
    this.borderRadius = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: width,
        height: size + 16.0,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon, color: Colors.white, size: size),
              if (icon != null) const SizedBox(width: 8.0),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 15, fontFamily: "Poppins", color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
