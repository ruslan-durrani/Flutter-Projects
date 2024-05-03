import 'package:flutter/material.dart';

class TopSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  TopSectionHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,style: Theme.of(context).textTheme.displayLarge,),
        Text(subtitle,style: Theme.of(context).textTheme.bodyMedium,)
      ],
    );
  }
}
