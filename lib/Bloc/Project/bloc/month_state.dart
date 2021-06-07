part of 'month_bloc.dart';

abstract class MonthState {
  const MonthState();
}

class MonthInitial extends MonthState {}

class MonthsGetSuccessfully extends MonthState {
  final List<MonthModel> months;
  MonthsGetSuccessfully(this.months);
}

class MonthsError extends MonthState {
  final String error;
  MonthsError(this.error);
}

class MonthsLoading extends MonthState {}

class MonthDeletedSuccessfully extends MonthState{}
class MonthAddedSuccessfully extends MonthState{}
