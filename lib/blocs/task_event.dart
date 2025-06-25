import 'package:equatable/equatable.dart';
import 'package:task_manager_with_project_sections_using_bloc/models/tasks.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskRequestEvent extends TaskEvent {
  @override
  List<Object?> get props => [];
}

class TaskInitialize extends TaskEvent {
  final Tasks? task;
  final int? index;

  TaskInitialize({required this.task, this.index});
  @override
  List<Object?> get props => [task, index];
}

class UpdateField extends TaskEvent {
  final String field;
  final dynamic value;
  UpdateField({required this.field, this.value});

  @override
  List<Object?> get props => [field, value];
}

class SubmitTask extends TaskEvent {}

class ClearForm extends TaskEvent {}

class TaskLoadEvent extends TaskEvent {
  final String? selectedCategory;
  final int filterStatus;
  TaskLoadEvent({this.selectedCategory, required this.filterStatus});
}

class TaskUpdateStatusEvent extends TaskEvent {
  final Tasks task;
  final bool status;
  TaskUpdateStatusEvent({required this.task, required this.status});

  @override
  List<Object?> get props => [task, status];
}

class TaskDeleteEvent extends TaskEvent {
  final Tasks tasks;
  TaskDeleteEvent({required this.tasks});
}
