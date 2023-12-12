// Convert Date Time object to String
String convertDateTimeToString(DateTime dateTime){
  // year in the format -> yyyy
  String year = dateTime.year.toString();
  // month in the format -> mm
  String month = dateTime.month.toString();
  month.length==1? month = "0$month" : month;
  // day in the format -> dd
  String day = dateTime.day.toString();
  day.length==1? day = "0$day" : day;
  // return date
  return year + month + day;

}