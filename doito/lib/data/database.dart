import 'package:hive_flutter/hive_flutter.dart';

class DoitoDatabase{
  List toDo = [];
  final _mybox = Hive.box("mybox");
  void createInitialData(){
    toDo.addAll([{
      "title":"Make Tutorial",
      "description":"description",
      "isChecked":true,
    },
      {
        "title":"Football Match",
        "description":"description",
        "isChecked":false,
      },
      {
        "title":"Final Year Project",
        "description":"description",
        "isChecked":true,
      }]);
  }
  //Fetch Data
  void loadData(){
    toDo = _mybox.get("DOITO");
  }
  //Update Data
  void updateDatabase(){
    _mybox.put("DOITO", toDo);
  }
}