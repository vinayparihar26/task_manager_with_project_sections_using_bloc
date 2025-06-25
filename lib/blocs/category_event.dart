import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {}

class AddCategory extends CategoryEvent {
  final String name;
  AddCategory({required this.name});

  @override
  List<Object?> get props => [name];
}

class DeleteCategory extends CategoryEvent {
  final int key;
  DeleteCategory({required this.key});

  @override
  List<Object?> get props => [key];
}
