import 'package:app_messenger_module/components/MyTextField.dart';
import 'package:flutter/material.dart';

import '../components/MyUserCardComponent.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static final routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Messages",style: TextStyle(
          color: Theme.of(context).primaryColor
        ),
        ),
      ),
        // MyTextField(hintText: "Search", isObscure: false, controller: TextEditingController()),
      body: Container(
        height: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Container(
          height: 200,
          child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context,index){
                return MyUserCardComponent();
              }),
        ),
      )
    );
  }
}
