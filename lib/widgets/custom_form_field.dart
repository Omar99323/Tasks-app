import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField(
      {super.key,
      required this.controler,
      required this.label,
      required this.icon,
      required this.type,
      required this.validator,
      required this.onsubmit,
      this.ontap});

  final TextEditingController controler;
  final String label;
  final IconData icon;
  final TextInputType type;
  final String Function(String?) validator;
  final void Function(String) onsubmit;
  final void Function()? ontap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controler,
      validator: validator,
      keyboardType: type,
      onTap: ontap,
      onFieldSubmitted: onsubmit,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: Text(label),
        prefixIcon: Icon(icon),
      ),
    );
  }
}
