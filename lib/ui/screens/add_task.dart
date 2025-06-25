import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:task_manager_with_project_sections_using_bloc/blocs/task_bloc.dart';
import 'package:task_manager_with_project_sections_using_bloc/blocs/task_event.dart';
import 'package:task_manager_with_project_sections_using_bloc/constants.dart';
import 'package:task_manager_with_project_sections_using_bloc/models/tasks.dart';
import 'package:task_manager_with_project_sections_using_bloc/responsive.dart';
import 'package:task_manager_with_project_sections_using_bloc/uihelper.dart';

class AddTask extends StatefulWidget {
  final String? selectedCategory;
  const AddTask({super.key, this.selectedCategory});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _peoplesController = TextEditingController();

  DateTime? selectedDateTime;
  String? priority;

  Uihelper helper = Uihelper();

  @override
  void initState() {
    super.initState();
    _categoryController.text = widget.selectedCategory ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _peoplesController.dispose();
    super.dispose();
  }

  Future<void> pickDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) return;

    setState(() {
      selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> saveTask() async {
    final taskBox = Hive.box<Tasks>('tasksBox');
    if (_titleController.text.isEmpty || _categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all required fields"),
          backgroundColor: primaryColor,
        ),
      );
      return;
    }

    final task = Tasks(
      title: _titleController.text,
      category: _categoryController.text,
      priority: priority,
      description: _descriptionController.text,
      peoples: _peoplesController.text,
      status: false,
      dateTime: selectedDateTime,
    );
    await taskBox.add(task);
    context.read<TaskBloc>().add(TaskLoadEvent(filterStatus: 0));
    Navigator.pop(context, true);
    await helper.showTaskAddAnimation(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xff73188f),
        onPressed: () {
          saveTask();
        },
        label: Text("Save Task", style: TextStyle(color: Colors.white)),
        icon: Icon(Icons.save, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFF009688),
        title: Text('Create Task'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        automaticallyImplyLeading: true,
      ),
      body: createTask(context),
    );
  }

  Padding createTask(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(child: createNewTask(context)),
        ),
      ),
    );
  }

  Column createNewTask(BuildContext context) {
    return Column(
      children: [
        helper.customInputField(
          icon: Icons.title,
          hint: 'Task title',
          controller: _titleController,
          context: context,
        ),
        SizedBox(height: 0.01 * getHeight(context)),

        helper.customInputField(
          icon: Icons.category,
          hint: 'Category',
          controller: _categoryController,
          context: context,
        ),
        SizedBox(height: 0.01 * getHeight(context)),

        helper.customInputField(
          icon: Icons.description,
          hint: 'Would you like to add more details?',
          controller: _descriptionController,
          context: context,
        ),
        SizedBox(height: 0.01 * getHeight(context)),

        helper.customInputField(
          icon: Icons.people_outline,
          hint: 'Peoples',
          controller: _peoplesController,
          context: context,
        ),
        SizedBox(height: 0.01 * getHeight(context)),
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          leading: Icon(CupertinoIcons.calendar, color: Color(0xFF009688)),

          trailing: IconButton(
            onPressed: () {
              pickDateTime();
            },
            icon: Icon(Icons.edit_calendar_rounded, color: Color(0xFF009688)),
          ),

          title: Text(
            selectedDateTime == null
                ? "Selected Due Date & Time"
                : " ${helper.formatDateTime(selectedDateTime!)}",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(height: 0.01 * getHeight(context)),
        ListTile(
          minVerticalPadding: 16,
          leading: Icon(Icons.label, color: Color(0xFF009688)),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          trailing: Icon(Icons.arrow_drop_down, color: Color(0xFF009688)),
          onTap: () {
            helper.showPriorityBottomSheet(context, (selectedPriority) {
              setState(() {
                priority = selectedPriority;
              });
            });
          },
          title:
              priority != null
                  ? Chip(
                    label: Text(priority ?? ''),
                    backgroundColor:
                        helper.priorityColor[priority] ?? Colors.grey,
                  )
                  : Text('Select Priority'),
        ),
        SizedBox(height: 0.01 * getHeight(context)),
      ],
    );
  }
}
