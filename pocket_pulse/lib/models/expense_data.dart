import 'package:pocket_pulse/utility/date_time_helper.dart';

import 'expense_item.dart';

class ExpenseData{
  List<ExpenseItem> listExpense = [];
  List<ExpenseItem> getListExpense() => listExpense;
  void addExpenseItem(ExpenseItem expenseItem) => listExpense.add(expenseItem);
  void removeExpenseItem(ExpenseItem expenseItem) => listExpense.remove(expenseItem);
  String getWeekDay(DateTime dateTime){
    switch(dateTime.weekday){
      case 1: return "Mon";
      case 2: return "Tue";
      case 3: return "Wed";
      case 4: return "Thur";
      case 5: return "Fri";
      case 6: return "Sat";
      case 7: return "Sun";
      default: return "";
    }
  }
  DateTime startOfTheWeekDate(){
    DateTime? startOfWeek;
    DateTime today = DateTime.now();
    for(int i = 0; i < 7; i++){
      if(getWeekDay(today.subtract(Duration(days: i)))=="Sun"){
        startOfWeek = today.subtract(Duration(days: i));
      }
    }
    return startOfWeek!;
  }
  Map<String,double> calculateDailyExpenseSummary(){
    Map<String,double> dailyExpenseSummary = {};
    for(var expense in listExpense){
      String date = convertDateTimeToString(expense.dateTime);
      double amount = expense.amount;
      String title = expense.name;
      if(dailyExpenseSummary.containsKey(date)){
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      }
      else{
        dailyExpenseSummary.addAll({date:amount});
      }
    }
    return dailyExpenseSummary;
  }
}