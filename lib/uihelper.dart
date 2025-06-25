import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:task_manager_with_project_sections_using_bloc/blocs/category_bloc.dart';
import 'package:task_manager_with_project_sections_using_bloc/blocs/category_event.dart';
import 'package:task_manager_with_project_sections_using_bloc/constants.dart';
import 'package:task_manager_with_project_sections_using_bloc/models/category_model.dart';
import 'package:task_manager_with_project_sections_using_bloc/responsive.dart';

class Uihelper {
  final priorities = ['Low', 'Medium', 'High', 'Urgent', 'No Priority'];
  final priorityColor = {
    'Low': Colors.green,
    'Medium': Colors.orange,
    'High': Colors.red,
    'Urgent': Colors.purple.shade400,
    'No Priority': Colors.grey,
  };

  void showPriorityBottomSheet(
    BuildContext context,
    Function(String) onSelect,
  ) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      context: context,
      builder: (_) {
        return Wrap(
          children:
              priorities.map((priority) {
                return ListTile(
                  leading: Icon(Icons.flag, color: priorityColor[priority]),
                  title: Text(priority),
                  onTap: () {
                    onSelect(priority.toString());
                    Navigator.pop(context);
                  },
                );
              }).toList(),
        );
      },
    );
  }

  showCategoryBottomSheet(BuildContext context, {CategoryModel? category}) {
    final TextEditingController _categoryController = TextEditingController(
      text: category?.name ?? '',
    );

    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
              ),
              SizedBox(height: 20),

              SizedBox(
                width: 150,
                child: ElevatedButton.icon(
                  icon: Icon(category == null ? Icons.add : Icons.update),
                  label: Text(
                    category == null ? 'Add Category' : 'Update Category',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff73188f),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    final name = _categoryController.text.trim();
                    if (name.isEmpty) return;

                    context.read<CategoryBloc>().add(AddCategory(name: name));
                    Navigator.pop(context);
                  },
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> showTaskAddAnimation(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Center(
              child: Container(
                width: 0.4 * getWidth(context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'assets/Animation - 1750786363981.json',
                      repeat: false,
                      onLoaded: (composition) {
                        Future.delayed(Duration(milliseconds: 1500), () {
                          Navigator.of(context).pop();
                        });
                      },
                    ),

                    Text(
                      "🎉 Task Added Successfully!",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return " ";
    final hour =
        dateTime.hour > 12
            ? dateTime.hour - 12
            : dateTime.hour == 0
            ? 12
            : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final ampm = dateTime.hour >= 12 ? 'PM' : 'AM';
    final date = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    return "$date at $hour:$minute $ampm";
  }

  Widget customInputField({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(icon, color: primaryColor),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12 * getResponsive(context)),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
        ),
      ),
    );
  }

  double verticalSpacing(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * percentage;
  }
}
