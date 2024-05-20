import 'package:flutter/material.dart';

class ReportInputWidget extends StatelessWidget {
  const ReportInputWidget(
      {super.key,
      required this.onChanged,
      required this.suffixText,
      required this.text});

  final Function(String) onChanged;
  final String suffixText;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        Expanded(
          child: SizedBox(
            height: 50,
            child: TextFormField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  labelText: '',
                  border: const OutlineInputBorder(),
                  suffixIcon: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(suffixText),
                    ],
                  )),
              onChanged: (value) {
                onChanged(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}
