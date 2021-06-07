part of 'actual_bloc.dart';

abstract class ActualState {
}

class ActualInitial extends ActualState {}
class ActualLoading extends ActualState {}
class GetActualTasksSuccessfully extends ActualState {
  final List<Event> list;
  GetActualTasksSuccessfully(this.list);
}
class GetDayActualTasksSuccessfully extends ActualState {
  final List<ListItemModel> list;
  GetDayActualTasksSuccessfully(this.list);
}
class GetActualTasksError extends ActualState {
  final String error;
  GetActualTasksError(this.error);
}
class ActualTaskError extends ActualState {
  final String error;
  ActualTaskError(this.error);
}

class InitAddActualSuccessfully extends ActualState{}
class InitUpdateActualSuccessfully extends ActualState{}
class AddActualSuccessfully extends ActualState{}
class UpdateActualSuccessfully extends ActualState{}
class DeleteActualSuccessfully extends ActualState{}

