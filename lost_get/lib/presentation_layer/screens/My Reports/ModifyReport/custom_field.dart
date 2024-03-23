import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final int maxLines;
  final int maxLength;
  final TextEditingController controller;
  final Function validatorFunction;
  const CustomField(
      {super.key,
      required this.maxLines,
      required this.maxLength,
      required this.controller,
      required this.validatorFunction});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        maxLength: maxLength,
        controller: controller,
        textAlign: TextAlign.start,
        validator: (value) => validatorFunction(value),
        style: Theme.of(context).textTheme.bodySmall,
        maxLines: maxLines == 0 ? null : maxLines,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),

          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4))),

          // floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
      ),
    );
  }
}
