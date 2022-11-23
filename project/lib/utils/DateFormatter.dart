import 'package:intl/intl.dart';

class DateFormatter{
  static String toRightFormat(DateTime dateTime){
    return DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);
  }
}