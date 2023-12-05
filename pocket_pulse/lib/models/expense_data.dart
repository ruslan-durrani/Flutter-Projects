import 'expense_item.dart';

class ExpenseData{
  List<ExpenseItem> listExpense = [];
  List<ExpenseItem> getListExpense() => listExpense;
  void addExpenseItem(ExpenseItem expenseItem) => listExpense.add(expenseItem);
  void removeExpenseItem(ExpenseItem expenseItem) => listExpense.remove(expenseItem);
  // TODO get week days
}