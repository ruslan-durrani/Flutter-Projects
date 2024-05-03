
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NavButton extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  NavButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData  = Theme.of(context);
    return InkWell(
      onTap: widget.onPressed,
      onHover: (value) {
        setState(() {
          hovered = value;
        });
      },
      child: Container(
        width: double.maxFinite,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color:  widget.isSelected || hovered ? themeData.colorScheme.inverseSurface.withOpacity(0.05) : themeData.colorScheme.secondary
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              "./assets/icons/${widget.label.toLowerCase()}.svg",
                color: widget.isSelected || hovered ? themeData.colorScheme.primary:themeData.colorScheme.primary.withOpacity(.3)

            ),
            SizedBox(width: 8,),
            Text(
              widget.label,
              style: themeData.textTheme.bodyLarge!.copyWith(
                  color: widget.isSelected?
                    themeData.colorScheme.primary:themeData.colorScheme.primary.withOpacity(.3),fontWeight: FontWeight.normal
              ),
            ),
          ],
        )
      ),
    );
  }
}