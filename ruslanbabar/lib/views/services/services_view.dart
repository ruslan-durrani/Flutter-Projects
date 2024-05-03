import 'package:flutter/cupertino.dart';

import '../../components/TopSectionHeader.dart';

class ServicesView extends StatelessWidget {
  const ServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TopSectionHeader(title: 'Services', subtitle: 'The services that i am offering',)
          ],
        ),
      ),
    );
  }
}
