import 'package:flutter/material.dart';

class ProfileHeaderItem extends StatelessWidget {
  final String text;
  final String number;
  const ProfileHeaderItem({Key? key, required this.text, required this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text(text), Text(number)],
    );
  }
}
