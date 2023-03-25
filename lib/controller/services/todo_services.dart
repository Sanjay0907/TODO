// ignore_for_file: prefer_const_constructors, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/constants/commonFunctions.dart';
import 'package:todo/controller/provider/todo_provider.dart';
import 'package:todo/model/todo_model.dart';
import 'dart:developer';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

class TODOServices {
  static fetchAllTodos() async {
    final data =
        firestore.collection(auth.currentUser!.phoneNumber!).snapshots();
    log(data.toString());
    return data;
  }

  static fetchLatestTodos(BuildContext context) {
    context.read<TODOProvider>().fetchTodos();
  }

  static Stream<List<TODOModel>> fetchTODOs({required String title}) =>
      firestore
          .collection(auth.currentUser!.phoneNumber!)
          .orderBy('lastUpdatedAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                log(TODOModel.fromMap(doc.data()).toMap().toString());
                return TODOModel.fromMap(doc.data());
              }).toList());

  static Future<List<TODOModel>> getTodos() async {
    List<TODOModel> allTodos = [];
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection(auth.currentUser!.phoneNumber!)
          .orderBy('lastUpdatedAt', descending: true)
          .get();

      snapshot.docs.forEach((element) {
        allTodos.add(TODOModel.fromMap(element.data()));
      });
    } catch (e) {
      log('error Found');
      log(e.toString());
    }

    for (var data in allTodos) {
      log(data.toMap().toString());
    }
    return allTodos;
  }

  static updateEntireTODO({
    required TODOModel todo,
    required String todoID,
  }) {
    DateTime lastUpdatedAt = DateTime.now();
    // Map<String, dynamic> updatedTODO = {
    //   'title': todo.title,
    //   'description': todo.description,
    //   'todos': todo.todos.map((x) => x.toMap()).toList(),
    //   'lastUpdatedAt': lastUpdatedAt,
    //   'todoID': todoID,
    // };
    Map<String, dynamic> todoModel = todo.toMap();

    FirebaseFirestore.instance
        .collection(auth.currentUser!.phoneNumber!)
        .doc(todoID)
        .set(
          todoModel,
        )
        .onError((error, stackTrace) => log(error.toString()));
  }

  static Future addNewTodo(
      {required TODOModel newTodo,
      required BuildContext context,
      required String docID}) async {
    DateTime now = DateTime.now();
    Map<String, dynamic> todoModel = newTodo.toMap();
    try {
      await firestore
          .collection(auth.currentUser!.phoneNumber!)
          .doc(docID)
          .set(todoModel)
          .whenComplete(() {
        log('Todo Added Successful');
        CommonFunctions.showToast(context: context, message: 'New Todo Added');
      });
    } catch (e) {
      log(e.toString());
      CommonFunctions.showToast(context: context, message: e.toString());
    }
  }

  static Future updateTodo(
      {required String documentID,
      required String todoID,
      required int todoIndex}) async {
    try {
      FirebaseFirestore.instance
          .collection(auth.currentUser!.phoneNumber!)
          .doc(documentID)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          List<dynamic> todos = data['todos'];
          int index = todos.indexWhere((todo) => todo['todoID'] == todoID);
          if (index != -1) {
            Map<String, dynamic> todo = todos[index];
            todo['todoDone'] =
                !todo['todoDone']; // update the todoDone property
            todos[index] = todo;
            FirebaseFirestore.instance
                .collection(auth.currentUser!.phoneNumber!)
                .doc(documentID)
                .update({'todos': todos}).onError(
                    (error, stackTrace) => log(error.toString()));
          }
        }
      });
    } catch (e) {
      log('error is \n ${e.toString()}');
    }
  }

  static Future deleteTodo({
    required String documentID,
  }) async {
    try {
      FirebaseFirestore.instance
          .collection(auth.currentUser!.phoneNumber!)
          .doc(documentID)
          .delete();
    } catch (e) {
      log('error is \n ${e.toString()}');
    }
  }
}
