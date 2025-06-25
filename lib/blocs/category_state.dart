import 'package:equatable/equatable.dart';
import 'package:task_manager_with_project_sections_using_bloc/models/category_model.dart';

abstract class CategoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categories;

  CategoryLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}
