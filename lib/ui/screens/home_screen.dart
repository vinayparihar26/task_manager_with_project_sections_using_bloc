import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:task_manager_with_project_sections_using_bloc/blocs/category_bloc.dart';
import 'package:task_manager_with_project_sections_using_bloc/blocs/category_event.dart';
import 'package:task_manager_with_project_sections_using_bloc/blocs/category_state.dart';
import 'package:task_manager_with_project_sections_using_bloc/blocs/task_bloc.dart';
import 'package:task_manager_with_project_sections_using_bloc/blocs/task_event.dart';
import 'package:task_manager_with_project_sections_using_bloc/blocs/task_state.dart';
import 'package:task_manager_with_project_sections_using_bloc/constants.dart';

import 'package:task_manager_with_project_sections_using_bloc/models/category_model.dart';
import 'package:task_manager_with_project_sections_using_bloc/models/tasks.dart';
import 'package:task_manager_with_project_sections_using_bloc/responsive.dart';
import 'package:task_manager_with_project_sections_using_bloc/ui/screens/add_task.dart';
import 'package:task_manager_with_project_sections_using_bloc/uihelper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool filterStatus = false;
  String? currentCategory;
  int currentFilter = 0;
  Uihelper helper = Uihelper();

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(TaskLoadEvent(filterStatus: 0));
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveValues(context);
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.tealAccent,
        title: Text(
          'Today\'s Tasks',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),

        actions: [taskFilter()],
      ),
      floatingActionButton: addTaskFBtn(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: Column(
              children: [
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
              
                    if (state is CategoryLoaded) {
                      final selectedCategory = context
                          .select<TaskBloc, String?>((bloc) {
                            final taskState = bloc.state;
                            if (taskState is TaskLoadedState) {
                              return taskState.selectedCategory;
                            }
                            return null;
                          });
                      return SizedBox(
                        height: responsive.sizeBox,
                        child: sectionList(
                          state.categories,
                          selectedCategory,
                          context,
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),

                BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    if (state is TaskLoadingState) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is TaskLoadedState) {
                      return SizedBox(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: state.tasks.length,
                          itemBuilder: (context, index) {
                            Tasks task = state.tasks[index];
                            return Dismissible(
                              key: UniqueKey(),
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (_) {
                                context.read<TaskBloc>().add(
                                  TaskDeleteEvent(tasks: task),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${task.title} deleted'),
                                  ),
                                );
                              },
                              child: taskList(task, context),
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          'No Task Found',
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row taskFilter() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            String? selectedCategory;
            if (state is TaskLoadedState) {
              currentCategory = state.selectedCategory;
              currentFilter = state.filterStatus;
              selectedCategory = state.selectedCategory;
            }
            return PopupMenuButton(
              onSelected: (filterStatus) {
                final currentState = context.read<TaskBloc>().state;

                if (currentState is TaskLoadedState) {
                  currentCategory = currentState.selectedCategory;
                }
                context.read<TaskBloc>().add(
                  TaskLoadEvent(
                    filterStatus: filterStatus,
                    selectedCategory: currentCategory,
                  ),
                );
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(value: 0, child: Text('All')),
                    PopupMenuItem(value: 1, child: Text('Completed')),
                    PopupMenuItem(value: 2, child: Text('Pending')),
                  ],
              icon: Icon(Icons.filter_list, color: Colors.black87),
            );
          },
        ),
      ],
    );
  }

  Card taskList(Tasks task, BuildContext context) {
    final responsive = ResponsiveValues(context);
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, softWrap: true, style: TextStyle(fontSize: responsive.fontSize),),
            Text(task.category, softWrap: true, style: TextStyle(fontSize: responsive.fontSize)),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.description ?? 'No description', softWrap: true, style: TextStyle(fontSize: responsive.fontSize),),
            SizedBox(height: 4),
            Text(
              " ${Uihelper().formatDateTime(task.dateTime)}",
              style: TextStyle(
                color: Colors.deepOrange,
                fontWeight: FontWeight.w500,
                fontSize: responsive.fontSize
              ),
            ),
          ],
        ),
        trailing:
            task.priority != null
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.flag,
                      color:
                          Uihelper().priorityColor[task.priority!] ??
                          Colors.grey,
                    ),

                    Text(
                      task.priority ?? 'No Priority',
                      style: TextStyle(
                        color:
                            Uihelper().priorityColor[task.priority!] ??
                            Colors.grey,fontSize: responsive.fontSize
                      ),
                    ),
                  ],
                )
                : SizedBox.shrink(),
        leading: Checkbox(
          value: task.status,
          onChanged: (value) {
            final newStatus = value ?? false;

            int filterStatus = 0;
            String? selectedCategory;
            final currentState = context.read<TaskBloc>().state;

            if (currentState is TaskLoadedState) {
              selectedCategory = currentState.selectedCategory;
              filterStatus = currentState.filterStatus;
            }

            context.read<TaskBloc>().add(
              TaskUpdateStatusEvent(task: task, status: newStatus),
            );

            context.read<TaskBloc>().add(
              TaskLoadEvent(
                filterStatus: filterStatus,
                selectedCategory: selectedCategory,
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  newStatus
                      ? 'Task "${task.title}" complete'
                      : 'Task "${task.title}" incomplete',
                ),
                backgroundColor: primaryColor,
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }

  ListView sectionList(
    List<CategoryModel> cat,
    String? selectedCategory,
    BuildContext context,
  ) {
    final responsive = ResponsiveValues(context);
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: cat.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return GestureDetector(
            onTap: () {
              context.read<TaskBloc>().add(
                TaskLoadEvent(selectedCategory: null, filterStatus: 0),
              );
            },

            child: Padding(
              padding: EdgeInsets.all(5),
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: 65),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(19),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6,
                    ),
                    child: Text(
                      'All',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.fontSize,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        if (index == cat.length + 1) {
          return Padding(
            padding: const EdgeInsets.all(4),
            child: Container(
              height: responsive.sizeBox,
              decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(19),
              ),
              child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6,
                    ),
                child: GestureDetector(
                  onTap: () {
                    Uihelper().showCategoryBottomSheet(context);
                  },
                  child: Text(
                    " + Create section",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.fontSize,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        final category = cat[index - 1];
        final isSelected = selectedCategory == category.name;
        return GestureDetector(
          onTap: () {
            context.read<TaskBloc>().add(
              TaskLoadEvent(selectedCategory: category.name, filterStatus: 0),
            );
          },
          onDoubleTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        AddTask(selectedCategory: category.name.toString()),
              ),
            );
          },
          onLongPress: () async {
            final category = cat[index - 1];
            final key = category.key;
            context.read<CategoryBloc>().add(DeleteCategory(key: key));

            await Future.delayed(Duration(milliseconds: 200));
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Category "${category.name}" deleted')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 65),
              child: Container(
                height: responsive.sizeBox,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.orange : Colors.transparent,
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6,
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    category.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: responsive.fontSize,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  FloatingActionButton addTaskFBtn(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: primaryColor,
      child: Icon(Icons.add, color: Colors.white),
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTask()),
        );

        if (result == true) {
          context.read<TaskBloc>().add(TaskLoadEvent(filterStatus: 0));
        }
      },
    );
  }
}
