import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lost_get/business_logic_layer/Provider/change_theme_mode.dart';
import 'package:lost_get/common/constants/add_report_constant.dart';
import 'package:lost_get/presentation_layer/screens/Add%20Report/sub_category_screen.dart';
import 'package:provider/provider.dart';

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  late List<Map<String, dynamic>> categoryList;

  @override
  void initState() {
    super.initState();
    categoryList = AddReportConstant(isDark: false).getCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeThemeMode>(
      builder: (context, ChangeThemeMode value, child) {
        ColorFilter? colorFilter = value.isDarkMode()
            ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
            : null;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "What are your reporting?",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: SvgPicture.asset(
                'assets/icons/exit_light.svg',
                width: 20,
                height: 20,
                colorFilter: colorFilter,
              ),
            ),
          ),
          body: SafeArea(
            child: ListView.builder(
              itemCount: categoryList.length,
              itemBuilder: (context, index) {
                var data = categoryList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.popAndPushNamed(
                      context,
                      SubCategoryScreen.route,
                      arguments: {
                        'categoryId': data["id"],
                      },
                    );
                  },
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: SvgPicture.asset(
                            data["imageUrl"],
                          ),
                        ),
                        title: Text(
                          data['title'],
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.2),
                        height: 1,
                        thickness: 1,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
