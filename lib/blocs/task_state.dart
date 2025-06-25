import 'package:equatable/equatable.dart';

import 'package:task_manager_with_project_sections_using_bloc/models/tasks.dart';

class TaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskInitialState extends TaskState {}

class TaskLoadingState extends TaskState {
  @override
  List<Object?> get props => [];
}

class TaskLoadedState extends TaskState {
  final List<Tasks> tasks;
  final int filterStatus;
  final String? selectedCategory;

  TaskLoadedState({
    required this.filterStatus,
    required this.tasks,
    required this.selectedCategory,
  });
  @override
  List<Object?> get props => [tasks, filterStatus, selectedCategory];
}

class TaskEmpty extends TaskState {}

class TaskErrorState extends TaskState {
  String errorMsg;
  TaskErrorState({required this.errorMsg});

  @override
  List<Object?> get props => [errorMsg];
}
