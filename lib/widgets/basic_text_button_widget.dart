import 'package:flutter/material.dart';

class BasicTextButtonWidget extends StatelessWidget {
  const BasicTextButtonWidget({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onClick,
  });

  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: TextButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            backgroundColor: backgroundColor),
        onPressed: () {
          onClick();
        },
        child: Text(
          text,
          style: TextStyle(fontSize: 20, color: textColor),
        ),
      ),
    );
  }
}