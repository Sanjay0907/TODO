// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:todo/constants/commonFunctions.dart';
import 'package:todo/controller/provider/todo_provider.dart';
import 'package:todo/controller/services/todo_services.dart';
import 'package:todo/model/todo_model.dart';
import 'package:todo/utils/colors.dart';
import 'package:todo/view/todo_screen/new_todo.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TextEditingController searchTextController = TextEditingController();
  searchTODO(String searchText) {
    List<TODOModel> result = [];
    List<TODOModel> allTodos = context.read<TODOProvider>().todo;
    if (searchText.isNotEmpty) {
      result = allTodos
          .where((element) =>
              element.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
      context.read<TODOProvider>().updateTodosFroSearchResult(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODOServices.getTodos();
          Navigator.push(
            context,
            PageTransition(
              child: const NewTodo(),
              type: PageTransitionType.rightToLeft,
            ),
          );
        },
        child: Icon(
          Icons.add,
          size: height * 0.04,
          color: white,
        ),
      ),
      body: SafeArea(
        child: Container(
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(
              vertical: height * 0.02, horizontal: width * 0.03),
          child: Column(
            children: [
              TextField(
                controller: searchTextController,
                cursorColor: textFieldCursorColor,
                style: textTheme.displaySmall,
                onChanged: (value) {
                  if (value.isEmpty) {
                    context.read<TODOProvider>().fetchTodos();
                  }
                  searchTODO(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search Here',
                  hintStyle:
                      textTheme.displaySmall!.copyWith(color: greyShade300),
                  // suffixIcon: IconButton(
                  //     onPressed: () {
                  //       searchTextController.clear();
                  //     },
                  //     icon: const Icon(Icons.close, color: white)),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: textFieldBorderColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: textFieldInactiveBorderColor,
                    ),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: textFieldBorderColor,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: textFieldBorderColor,
                    ),
                  ),
                ),
              ),
              CommonFunctions.blankSpace(
                context: context,
                reqHeight: 0.02,
                reqWidth: 0,
              ),
              Expanded(
                child: StreamBuilder<List<TODOModel>>(
                  stream: TODOServices.fetchTODOs(
                      title: searchTextController.text.trim()),
                  builder: (context, snapshot) {
                    log(snapshot.error.toString());
                    if (snapshot.hasData) {
                      final todos = snapshot.data;
                      context.read<TODOProvider>().updateAllTodos(todos!);
                      if (searchTextController.text.isNotEmpty) {
                        searchTODO(searchTextController.text.trim());
                      }
                      return Consumer<TODOProvider>(
                          builder: (context, todoProvider, child) {
                        return Builder(builder: (context) {
                          if (todoProvider.todo.isEmpty) {
                            return Center(
                              child: Text(
                                'Add Todo',
                                style: textTheme.bodyMedium!
                                    .copyWith(color: white),
                              ),
                            );
                          } else {
                            return ListView.builder(
                                itemCount: todoProvider.todo.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  log(todos.length.toString());
                                  TODOModel currentTodo =
                                      todoProvider.todo[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => NewTodo(
                                                    updateTODO: currentTodo,
                                                  )));
                                    },
                                    child: Container(
                                      width: width,
                                      margin: EdgeInsets.symmetric(
                                          vertical: height * 0.01),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                            colors: gradient1,
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.02,
                                        vertical: height * 0.01,
                                      ),
                                      child: Stack(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                currentTodo.title,
                                                style: textTheme.bodyMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: black),
                                              ),
                                              CommonFunctions.blankSpace(
                                                context: context,
                                                reqHeight: 0.01,
                                                reqWidth: 0,
                                              ),
                                              Text(
                                                currentTodo.description ?? '',
                                                style: textTheme.bodySmall,
                                              ),
                                              ListView.builder(
                                                  itemCount:
                                                      currentTodo.todos.length,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (context, todoIndex) {
                                                    Todos cTodos = currentTodo
                                                        .todos[todoIndex];
                                                    return Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            TODOServices.updateTodo(
                                                                documentID:
                                                                    currentTodo
                                                                        .todoID,
                                                                todoID: cTodos
                                                                    .todoID,
                                                                todoIndex:
                                                                    todoIndex);
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        height *
                                                                            0.005),
                                                            height:
                                                                height * 0.03,
                                                            width:
                                                                height * 0.03,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color: white,
                                                            ),
                                                            child: Icon(
                                                              Icons.check,
                                                              // color: black,
                                                              color: cTodos
                                                                      .todoDone
                                                                  ? black
                                                                  : transparent,
                                                            ),
                                                          ),
                                                        ),
                                                        CommonFunctions
                                                            .blankSpace(
                                                          context: context,
                                                          reqHeight: 0,
                                                          reqWidth: 0.03,
                                                        ),
                                                        Text(
                                                          cTodos.todo,
                                                          style: textTheme
                                                              .bodyMedium,
                                                        )
                                                      ],
                                                    );
                                                  })
                                            ],
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: IconButton(
                                                onPressed: () {
                                                  TODOServices.deleteTodo(
                                                      documentID:
                                                          currentTodo.todoID);
                                                },
                                                icon: Icon(Icons.delete)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }
                        });
                      });
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Opps! something went wrong',
                          style: textTheme.bodyMedium!.copyWith(color: white),
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          'Add Todo',
                          style: textTheme.bodyMedium!.copyWith(color: white),
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
