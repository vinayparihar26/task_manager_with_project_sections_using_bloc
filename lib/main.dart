import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_with_project_sections_using_bloc/blocs/category_bloc.dart';
import 'package:task_manager_with_project_sections_using_bloc/blocs/category_event.dart';
import 'package:task_manager_with_project_sections_using_bloc/blocs/task_bloc.dart';
import 'package:task_manager_with_project_sections_using_bloc/blocs/task_event.dart';
import 'package:task_manager_with_project_sections_using_bloc/models/category_model.dart';
import 'package:task_manager_with_project_sections_using_bloc/models/tasks.dart';
import 'package:task_manager_with_project_sections_using_bloc/ui/screens/home_screen.dart';

import 'package:hive_flutter/hive_flutter.dart';

late Box<Tasks> taskBox;
var categoryBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TasksAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  taskBox = await Hive.openBox<Tasks>('tasksBox');
  print("✨ Box count: ${taskBox.length}");

  categoryBox = await Hive.openBox<CategoryModel>('categoryBox');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CategoryBloc(categoryBox)..add(LoadCategories()),
        ),
        BlocProvider(create: (context) => TaskBloc(taskBox)),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
