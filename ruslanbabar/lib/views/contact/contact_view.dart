import 'package:flutter/cupertino.dart';

import '../../components/TopSectionHeader.dart';
import '../../utils/responsive.dart';

class ContactView extends StatelessWidget {
  const ContactView({super.key});

  @override
  Widget build(BuildContext context) {
    final double pad =  28.0;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TopSectionHeader(title: 'Contact', subtitle: 'Information about your current plan and usages',)
            ],
          ),

        ],
      ),
    );
  }
}
