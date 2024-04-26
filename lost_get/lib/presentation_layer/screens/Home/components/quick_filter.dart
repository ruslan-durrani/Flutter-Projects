import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:lost_get/presentation_layer/screens/Add%20Report/map_screen.dart';

class QuickFilterBar extends StatefulWidget {
  final Function(String) onFilterSelected;
  final List<String> categories;
  final Function() setLocationData;
  QuickFilterBar(
      {super.key,required this.setLocationData, required this.onFilterSelected, required this.categories});

  @override
  // ignore: library_private_types_in_public_api
  _QuickFilterBarState createState() => _QuickFilterBarState();
}

class _QuickFilterBarState extends State<QuickFilterBar> {
  int _selectedCategoryIndex = 0;


  void _selectCategory(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
    widget.onFilterSelected(widget.categories[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(color: Colors.grey.withOpacity(0.2), width: 2))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          // Wrap the ListView with a Container and give it a bounded height
          Expanded(
            child: Container(
              height: 36.0, // Set a fixed height for the ListView
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.categories.length,
                itemBuilder: (BuildContext context, int index) {
                  // return Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  //   child: ChoiceChip(
                  //     showCheckmark: false,
                  //     label: Text(widget.categories[index]),
                  //     selected: _selectedCategoryIndex == index,
                  //
                  //     onSelected: (_) => _selectCategory(index),
                  //     selectedColor: Theme.of(context).colorScheme.primary,
                  //     labelStyle: TextStyle(
                  //       color: _selectedCategoryIndex == index
                  //           ? Colors.white
                  //           : Colors.black,
                  //     ),
                  //     backgroundColor: Theme.of(context).colorScheme.background,
                  //   ),
                  // );
                  return GestureDetector(
                    onTap: () => _selectCategory(index),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      margin: EdgeInsets.only(right: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(width: 1,color: _selectedCategoryIndex == index
                            ? AppColors.primaryColor
                            : Colors.white,),
                        color: _selectedCategoryIndex == index
                            ? AppColors.primaryColor
                            : Colors.grey.withOpacity(.2),
                      ),
                      child: Text(
                        widget.categories[index],
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: _selectedCategoryIndex == index
                              ? Colors.white
                              : Colors.black,
                        ),
                      )
                    ),
                  );
                },
              ),
            ),
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/location_icon.svg',
              width: 30,
            ),
            onPressed: ()=>widget.setLocationData(),
          ),
          // IconButton(
          //   icon: SvgPicture.asset(
          //     'assets/icons/filter_icon.svg',
          //     width: 35,
          //   ), // Replace with your filter SVG asset
          //   onPressed: () {},
          // ),
        ],
      ),
    );
  }
}
