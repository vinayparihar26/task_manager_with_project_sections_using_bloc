import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:task_manager_with_project_sections_using_bloc/blocs/category_event.dart';
import 'package:task_manager_with_project_sections_using_bloc/blocs/category_state.dart';
import 'package:task_manager_with_project_sections_using_bloc/models/category_model.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final Box<CategoryModel> categoryBox;

  CategoryBloc(this.categoryBox) : super(CategoryInitial()) {
    on<LoadCategories>((event, emit) {
      final categories = categoryBox.values.toList();
      emit(CategoryLoaded(categories));
    });

    on<AddCategory>((event, emit) async {
      await categoryBox.add(CategoryModel(name: event.name));
      add(LoadCategories());
    });

    on<DeleteCategory>((event, emit) async {
      await Future(() async {
        await categoryBox.delete(event.key);
      });

      add(LoadCategories());
    });
  }
}
