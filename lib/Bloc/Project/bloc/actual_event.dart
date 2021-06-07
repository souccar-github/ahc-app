part of 'actual_bloc.dart';

abstract class ActualEvent {}

class GetDayTasks extends ActualEvent {
  final int id;
  final DateTime date;
  GetDayTasks(this.date, this.id);
}

class GetActualTasks extends ActualEvent {
  final int id;
  GetActualTasks(this.id);
}

class InitAddActualTask extends ActualEvent {}

class InitUpdateActualTask extends ActualEvent {}

class DeleteActualTask extends ActualEvent {
  final String type;
  final int id;
  DeleteActualTask(this.id, this.type);
}

class AddActualTask extends ActualEvent {}

class UpdateActualTask extends ActualEvent {}
