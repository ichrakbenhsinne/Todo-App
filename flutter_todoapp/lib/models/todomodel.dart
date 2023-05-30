import 'package:flutter/services.dart';

class Todo {
  final int? id;
   String title;
   String description;
  bool etat;
   DateTime date;

  Todo({
    required this.title,
    required this.description,
    required this.etat,
    required this.date,
    this.id,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as int?,
      title: json['title'] as String,
      description: json['description'] as String,
      etat: json['etat'] as bool,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'etat': etat,
      'date': date.toIso8601String(),
    };
  }
}
