import 'package:flutter/material.dart';

class PasswordToggle extends StatefulWidget {
  final ValueChanged<bool> onChanged;

  const PasswordToggle({Key? key, required this.onChanged}) : super(key: key);

  @override
  _PasswordToggleState createState() => _PasswordToggleState();
}

class _PasswordToggleState extends State<PasswordToggle> {
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
      widget.onChanged(_obscureText); // 상태 전달
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: Icon(
        _obscureText ? Icons.visibility : Icons.visibility_off,
      ),
    );
  }
}
