import 'package:flutter/material.dart';

import '../../features/chat/screens/message_screen.dart';
import '../../features/dashboard/screens/article/articles_screen.dart';
import '../../features/profile/screens/book_marks_screen.dart';
import '../../features/profile/screens/booking_view.dart';

class GetDrawer extends StatelessWidget {
  const GetDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Add your drawer items here
        children: <Widget>[
          Card(
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BookingView()));
              },
              child: Container(
                padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("My Bookings"),
                      Icon(Icons.arrow_forward,color: Colors.black,)
                    ],
                  )),
            ),

          ),
          Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const ArticlesViewScreen(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Suggested Articles"),
                      Icon(Icons.arrow_forward,color: Colors.black,)
                    ],
                  )),
            ),

          ),
          Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const MessageScreen(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Messages"),
                      Icon(Icons.arrow_forward,color: Colors.black,)
                    ],
                  )),
            ),

          ),
          Card(
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, BookMarksScreen.routeName);
              },
              child: Container(
                padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Saved Posts"),
                      Icon(Icons.arrow_forward,color: Colors.black,)
                    ],
                  )),
            ),

          ),
          // Add more items...
        ],
      ),
    );
  }
}
