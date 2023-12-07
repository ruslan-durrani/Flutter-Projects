import 'expense_item.dart';

class ExpenseData{
  List<ExpenseItem> listExpense = [];
  List<ExpenseItem> getListExpense() => listExpense;
  void addExpenseItem(ExpenseItem expenseItem) => listExpense.add(expenseItem);
  void removeExpenseItem(ExpenseItem expenseItem) => listExpense.remove(expenseItem);
  String getWeekDay(){
    switch(DateTime.now()){
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
}