import 'dart:async';

import 'package:task_manager_with_project_sections_using_bloc/blocs/task_event.dart';
import 'package:task_manager_with_project_sections_using_bloc/blocs/task_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:task_manager_with_project_sections_using_bloc/models/tasks.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final Box<Tasks> taskBox;

  TaskBloc(this.taskBox) : super(TaskInitialState()) {
    on<TaskLoadEvent>((event, emit) async {
      await Future.delayed(Duration(milliseconds: 100));
      List<Tasks> allTasks =
          event.selectedCategory == null ||
                  event.selectedCategory!.trim().isEmpty
              ? taskBox.values.toList()
              : taskBox.values
                  .where(
                    (task) =>
                        task.category.trim().toLowerCase() ==
                        event.selectedCategory!.trim().toLowerCase(),
                  )
                  .toList();

      List<Tasks> filteredTasks;
      if (event.filterStatus == 1) {
        filteredTasks = allTasks.where((task) => task.status == true).toList();
      } else if (event.filterStatus == 2) {
        filteredTasks = allTasks.where((task) => task.status == false).toList();
      } else {
        filteredTasks = allTasks;
      }

      emit(
        TaskLoadedState(
          tasks: filteredTasks,
          filterStatus: event.filterStatus,
          selectedCategory: event.selectedCategory,
        ),
      );
    });

    on<TaskUpdateStatusEvent>((event, emit) async {
      final key = event.task.key;
      if (key != null) {
        final updatedTask = Tasks(
          title: event.task.title,
          category: event.task.category,
          priority: event.task.priority,
          description: event.task.description,
          peoples: event.task.peoples,
          status: event.status,
          dateTime: event.task.dateTime,
        );

        final currentState = state;
        int currentFilterStatus = 0;
        String? currentSelectedCategory;
        if (currentState is TaskLoadedState) {
          currentFilterStatus = currentState.filterStatus;
          currentSelectedCategory = currentState.selectedCategory;
        }
        await taskBox.put(key, updatedTask);
        add(
          TaskLoadEvent(
            filterStatus: currentFilterStatus,
            selectedCategory: currentSelectedCategory,
          ),
        );
      }
    });

    on<TaskDeleteEvent>((event, emit) {
      taskBox.delete(event.tasks.key);
      add(TaskLoadEvent(filterStatus: 0));
    });
  }
}
