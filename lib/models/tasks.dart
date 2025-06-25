import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'tasks.g.dart';

@HiveType(typeId: 0)
class Tasks extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String category;

  @HiveField(2)
  String? priority;

  @HiveField(3)
  String? description;

  @HiveField(4)
  String? peoples;

  @HiveField(5)
  bool? status;

  @HiveField(6)
  DateTime? dateTime;

  Tasks({
    required this.title,
    required this.category,
    this.priority,
    this.description,
    this.peoples,
    this.status = false,
    this.dateTime,
  });
}
