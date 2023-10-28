import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memoir/components/my_drawer.dart';
import 'package:memoir/components/my_list_tile.dart';
import 'package:memoir/components/my_postButton.dart';
import 'package:memoir/components/my_textField.dart';
import 'package:memoir/database/firestore.dart';
import 'package:memoir/helper/helper_functions.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/home_page";

  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController saySomething = TextEditingController();

  FirestoreDatabase database = FirestoreDatabase();

  Future<void> postMemoir() async {
    if(saySomething.text.isNotEmpty){
      await database.postMemoir(saySomething.text).then((value){
        displayMessageToUser(context, "Memoir Published Successfully 🚀");
      });
    }
    saySomething.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("M O I R"),
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(child: MyTextField(controller: saySomething, hintText: "write your article..", obscureText: false)),
                MyPostButton(onTap: postMemoir,)
              ],
            ),
          ),
          StreamBuilder(
              stream: database.getMemoirs(),
              builder: (context,snapshot){

                if(snapshot.hasError){
                  displayMessageToUser(context, snapshot.error.toString());
                }
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(color: Theme.of(context).colorScheme.inversePrimary,),
                  );
                }
                final memoirs = snapshot.data!.docs;
                if(snapshot.hasData){
                  return Expanded(
                    child: ListView.builder(
                      itemCount: memoirs.length,
                        itemBuilder: (context,index){
                        final memoir = memoirs[index];
                        final message = memoir["MemoirMessage"];
                        final userEmail = memoir["UserEmail"];
                        final timeStamp = memoir["Timestamp"];
                        return Container(
                            margin: const EdgeInsets.symmetric(vertical: 6,horizontal: 15),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(.2),
                            // borderRadius: BorderRadius.circular(12)
                          ),
                            child: MyListTile(title: message, subTitle: userEmail));
                    }),
                  );
                }
                else{
                  return const Center(child: Text("No Data"),);
                }
              }
              ),
        ]
      ),
    );
  }
}
