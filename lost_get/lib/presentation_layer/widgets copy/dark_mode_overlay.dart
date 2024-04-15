import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_get/business_logic_layer/Provider/change_theme_mode.dart';
import 'package:provider/provider.dart';

class DarkModeOverlay extends StatelessWidget {
  const DarkModeOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ChangeThemeMode changeThemeMode, child) => AlertDialog(
        title: const Text("Select Theme"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<int>(
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              hoverColor: null,
              title: Text(
                "No",
                style: GoogleFonts.roboto(
                  color: changeThemeMode.isDarkMode()
                      ? Colors.white
                      : Colors.black,
                  fontSize: 14,
                  fontWeight: changeThemeMode.isDyslexia
                      ? FontWeight.bold
                      : FontWeight.w700,
                ),
              ),
              groupValue: changeThemeMode.darkMode,
              onChanged: (value) {
                print("value passed $value");
                changeThemeMode.toggleTheme(value!);
              },
              value: 0,
            ),
            RadioListTile<int>(
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              hoverColor: null,
              title: Text(
                "Yes",
                style: GoogleFonts.roboto(
                  color: changeThemeMode.isDarkMode()
                      ? Colors.white
                      : Colors.black,
                  fontSize: 14,
                  fontWeight: changeThemeMode.isDyslexia
                      ? FontWeight.bold
                      : FontWeight.w700,
                ),
              ),
              groupValue: changeThemeMode.darkMode,
              onChanged: (value) {
                print("value 2 passed $value");
                changeThemeMode.toggleTheme(value!);
              },
              value: 1,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
