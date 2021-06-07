part of 'month_bloc.dart';

abstract class MonthEvent {
}

class GetMonths extends MonthEvent{
}

class AddNewMonth extends MonthEvent{
  final int month;
  final int year;
  AddNewMonth(this.year,this.month);
}

class UpdateMonth extends MonthEvent{
  final int id;
  final int month;
  final int year;
  UpdateMonth(this.year,this.month,this.id);
}

class DeleteMonth extends MonthEvent{
  final int id;
  DeleteMonth(this.id);
}
