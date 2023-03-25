import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class TODOModel {
  final String title;
  String? description;
  final List<Todos> todos;
  final DateTime lastUpdatedAt;
  final String todoID;
  TODOModel({
    required this.title,
    this.description,
    required this.todos,
    required this.lastUpdatedAt,
    required this.todoID,
  });

  // factory TODOModel.fromFirestore(DocumentSnapshot doc) {
  //   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //   return TODOModel(
  //     title: data['title'] as String,
  //     description:
  //         data['description'] != null ? data['description'] as String : null,
  //     todos: List<Todos>.from(
  //       (data['todos'] as List<int>).map<Todos>(
  //         (x) => Todos.fromMap(x as Map<String, dynamic>),
  //       ),
  //     ),
  //     lastUpdatedAt:
  //         DateTime.fromMillisecondsSinceEpoch(data['lastUpdatedAt'] as int),
  //   );
  // }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'todos': todos.map((x) => x.toMap()).toList(),
      'lastUpdatedAt': lastUpdatedAt.millisecondsSinceEpoch,
      'todoID': todoID,
    };
  }

  factory TODOModel.fromMap(Map<String, dynamic> map) {
    return TODOModel(
      title: map['title'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      todos: List<Todos>.from(
        (map['todos'] as List<dynamic>).map<Todos>(
          (x) => Todos.fromMap(x as Map<String, dynamic>),
        ),
      ),
      lastUpdatedAt:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdatedAt'] as int),
      todoID: map['todoID'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TODOModel.fromJson(String source) =>
      TODOModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Todos {
  String todo;
  bool todoDone;
  String todoID;
  Todos({
    required this.todo,
    required this.todoDone,
    required this.todoID,
  });

  factory Todos.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Todos(
      todo: data['todo'] as String,
      todoDone: data['todoDone'] as bool,
      todoID: data['todoID'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'todo': todo,
      'todoDone': todoDone,
      'todoID': todoID,
    };
  }

  factory Todos.fromMap(Map<String, dynamic> map) {
    return Todos(
      todo: map['todo'] as String,
      todoDone: map['todoDone'] as bool,
      todoID: map['todoID'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Todos.fromJson(String source) =>
      Todos.fromMap(json.decode(source) as Map<String, dynamic>);
}
