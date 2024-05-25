import 'package:flutter/material.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';
import 'package:mental_healthapp/shared/utils/goals_database.dart';
import 'package:mental_healthapp/shared/constants/utils/helper_button.dart';
import 'package:mental_healthapp/shared/constants/utils/helper_textfield.dart';
import 'package:provider/provider.dart';

class GoalDetails extends StatefulWidget {
  final String name;
  final String img;
  final List goalList;
  const GoalDetails(
      {super.key,
      required this.name,
      required this.img,
      required this.goalList});

  @override
  State<GoalDetails> createState() => _GoalDetailsState();
}

class _GoalDetailsState extends State<GoalDetails> {
  TextEditingController goalController = TextEditingController();
  void addMsg(String msg) {
    setState(() {
      goalController.text = msg;
    });
  }

  int selectedIndex = -1;
  @override
  void dispose() {
    super.dispose();
    goalController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: EColors.primaryColor,
        leading: InkWell(
            onTap: ()=>Navigator.pop(context),
            child: Icon(Icons.keyboard_backspace_outlined,color: Colors.white,)),
        title: Text("${widget.name}",style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Center(child: Image(image: AssetImage(widget.img))),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Pick from our suggestions",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: EColors.textPrimary),
              ),
              const SizedBox(
                height: 20,
              ),
              Wrap(
                runSpacing: 10,
                spacing: 15,
                direction: Axis.horizontal,
                children: List.generate(widget.goalList.length, (index) {
                  return PreGoals(
                      msg: widget.goalList[index],
                      isSelected: selectedIndex == index,
                      onTap: (msg) {
                        setState(() {
                          selectedIndex = index;
                          goalController.text = msg;
                        });
                      });
                }),
              ),
              const Divider(),
              const SizedBox(
                height: 20,
              ),
              Text(
                "CREATE YOUR OWN",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: EColors.textPrimary),
              ),
              HelperTextField(
                  htxt: goalController.text.toString(),
                  iconData: Icons.add,
                  controller: goalController,
                  keyboardType: TextInputType.name),
              HelperButton(
                  isPrimary:true,
                  name: 'Save',
                  onTap: () {
                    final db = Provider.of<GoalDataBase>(context, listen: false);
                    db.saveTask(goalController, context);
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class PreGoals extends StatelessWidget {
  final String msg;
  final bool isSelected;
  final Function(String) onTap;

  const PreGoals(
      {super.key,
      required this.msg,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(msg); // Pass the message to the callback function
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? EColors.primaryColor : EColors.grey.withOpacity(.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(msg,style: TextStyle(color: isSelected?EColors.white:EColors.textPrimary.withOpacity(.8)),),
        ),
      ),
    );
  }
}
