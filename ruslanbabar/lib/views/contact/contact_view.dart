import 'package:flutter/cupertino.dart';

import '../../components/TopSectionHeader.dart';

class ContactView extends StatelessWidget {
  const ContactView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TopSectionHeader(title: 'Contact', subtitle: "Let\'s get connected and discuss your project"),
          ],
        ),
      ),
    );
  }
}
