import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lost_get/business_logic_layer/Provider/change_theme_mode.dart';
import 'package:lost_get/common/constants/add_report_constant.dart';
import 'package:lost_get/presentation_layer/screens/Add%20Report/add_report_detail_screen.dart';
import 'package:provider/provider.dart';

class SubCategoryScreen extends StatefulWidget {
  final int categoryId;
  const SubCategoryScreen({super.key, required this.categoryId});

  static const String route = "/sub_cat_screen";

  factory SubCategoryScreen.fromArguments(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final categoryId = args['categoryId'];

    return SubCategoryScreen(categoryId: categoryId);
  }

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  late Map<String, dynamic> categoryList;

  @override
  void initState() {
    super.initState();
    categoryList = AddReportConstant(isDark: false)
        .getCategoryList()
        .firstWhere((element) => element["id"] == widget.categoryId);
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
                'assets/icons/back.svg',
                width: 32,
                height: 32,
                colorFilter: colorFilter,
              ),
            ),
          ),
          body: SafeArea(
            child: ListView.builder(
              itemCount: categoryList['subCat'].length,
              itemBuilder: (context, index) {
                var data = categoryList['subCat'][index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AddReportDetailScreen.routeName,
                      arguments: {
                        'categoryId': categoryList['id'],
                        'subCategoryName': data["title"]
                      },
                    );
                  },
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
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
