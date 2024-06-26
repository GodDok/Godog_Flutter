import 'package:flutter/material.dart';
import 'package:godog/widgets/password_toggle_widget.dart';

class PasswordInputWidget extends StatelessWidget {
  final bool passwordCheckObscureText;
  final String label;
  final Function(bool) suffixClick;
  final Function(String) onChanged;

  const PasswordInputWidget({
    super.key,
    required this.passwordCheckObscureText,
    required this.suffixClick,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText: passwordCheckObscureText,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelStyle: TextStyle(color: Colors.blueAccent),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        suffixIcon: PasswordToggle(
          onChanged: (value) {
            suffixClick(value);
          },
        ),
      ),
      onChanged: (value) {
        onChanged(value);
      },
    );
  }
}
