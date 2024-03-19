import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class QuickFilterBar extends StatefulWidget {
  final Function(String) onFilterSelected;
  final List<String> categories;

  QuickFilterBar({Key? key, required this.onFilterSelected, required this.categories}) : super(key: key);

  @override
  _QuickFilterBarState createState() => _QuickFilterBarState();
}

class _QuickFilterBarState extends State<QuickFilterBar> {
  int _selectedCategoryIndex = 0; // 'All' is selected by default
  List<String> categories = ['All',"Electronics" ,"Human",'Mobile', 'Cars', 'Wallet'];

  void _selectCategory(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
    widget.onFilterSelected(categories[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: SvgPicture.asset('assets/icons/location_icon.svg'), // Replace with your location SVG asset
            onPressed: () {
              // TODO: Navigate to location filter
            },
          ),
          // Wrap the ListView with a Container and give it a bounded height
          Expanded(
            child: Container(
              height: 36.0, // Set a fixed height for the ListView
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      showCheckmark: false,

                      label: Text(categories[index]),
                      selected: _selectedCategoryIndex == index,
                      onSelected: (_) => _selectCategory(index),
                      selectedColor: Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(
                        color: _selectedCategoryIndex == index ? Colors.white : Colors.black,
                      ),
                      backgroundColor: Theme.of(context).colorScheme.background,
                    ),
                  );
                },
              ),
            ),
          ),
          IconButton(
            icon: SvgPicture.asset('assets/icons/filter_icon.svg'), // Replace with your filter SVG asset
            onPressed: () {
              // TODO: Navigate to filter bottomSheet
            },
          ),
        ],
      ),
    );
  }
}
