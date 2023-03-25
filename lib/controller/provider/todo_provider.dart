import 'package:flutter/material.dart';
import 'package:todo/controller/services/todo_services.dart';
import 'package:todo/model/todo_model.dart';

class TODOProvider extends ChangeNotifier {
  TODOProvider() {
    fetchTodos();
  }
  List<TODOModel> todo = [];
  List<Todos> todosChecklist = [];
  bool fetchedTodos = false;
  TODOModel newTodo = TODOModel(
      todoID: '',
      title: '',
      todos: [
        Todos(todo: '', todoDone: false, todoID: ''),
      ],
      lastUpdatedAt: DateTime.now());

  fetchTodos() async {
    todo = await TODOServices.getTodos();
    fetchedTodos = true;
    notifyListeners();
  }

  updateAllTodos(List<TODOModel> todos) {
    todo = todos;
    notifyListeners();
  }

  updateTodosFroSearchResult(List<TODOModel> result) {
    todo = result;
    notifyListeners();
  }

  addTodoToChecklist({required Todos todo}) {
    todosChecklist.add(todo);
    notifyListeners();
  }

  updateTodosChecklist(int index, Todos todo) {
    todosChecklist[index] = todo;
    notifyListeners();
  }

  deleteTodosFromChecklist(int index) {
    todosChecklist.removeAt(index);
    notifyListeners();
  }

  clearTodosCheckList() {
    todosChecklist = [];
    notifyListeners();
  }

  eraseTodosFromChecklist() {
    todosChecklist = [];
    notifyListeners();
  }

  addNewTodo({required TODOModel addtodo}) {}
}
