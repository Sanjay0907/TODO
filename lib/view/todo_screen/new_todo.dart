import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/constants/commonFunctions.dart';
import 'package:todo/controller/provider/todo_provider.dart';
import 'package:todo/controller/services/todo_services.dart';
import 'package:todo/model/todo_model.dart';
import 'package:todo/utils/colors.dart';
import 'package:uuid/uuid.dart';

class NewTodo extends StatefulWidget {
  const NewTodo({super.key, this.updateTODO});

  final TODOModel? updateTODO;

  @override
  State<NewTodo> createState() => _NewTodoState();
}

class _NewTodoState extends State<NewTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController todoController = TextEditingController();
  addTodo() async {
    if (titleController.text.isEmpty) {
      CommonFunctions.showToast(context: context, message: 'Enter Todo Title');
    } else if (context.read<TODOProvider>().todosChecklist.isEmpty) {
      CommonFunctions.showToast(context: context, message: 'Please Add TODO');
    } else if (widget.updateTODO != null) {
      DateTime dateTime = DateTime.now();
      log(dateTime.toString());
      List<Todos> todos = context.read<TODOProvider>().todosChecklist;
      // String docID = uuid.v1();
      TODOModel updatedTodo = TODOModel(
          todoID: widget.updateTODO!.todoID,
          title: titleController.text.trim(),
          todos: todos,
          lastUpdatedAt: dateTime);
      await TODOServices.updateEntireTODO(
          todo: updatedTodo, todoID: widget.updateTODO!.todoID);
    } else {
      DateTime dateTime = DateTime.now();
      List<Todos> todos = context.read<TODOProvider>().todosChecklist;
      Uuid uuid = Uuid();
      String docID = uuid.v1();
      TODOModel newTodo = TODOModel(
          todoID: docID,
          title: titleController.text.trim(),
          todos: todos,
          lastUpdatedAt: dateTime);
      await TODOServices.addNewTodo(
          newTodo: newTodo, context: context, docID: docID);
      // popScreen();
    }
  }

  popScreen() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TODOProvider>().clearTodosCheckList();
      if (widget.updateTODO != null) {
        titleController.text = widget.updateTODO!.title;

        for (var data in widget.updateTODO!.todos) {
          context.read<TODOProvider>().addTodoToChecklist(todo: data);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: transparent,
        leading: IconButton(
            onPressed: () => popScreen(),
            icon: Icon(
              Icons.arrow_back,
              color: white,
              size: height * 0.04,
            )),
        title: Text(
          'New Todo',
          style: textTheme.displayMedium,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              addTodo();
              context.read<TODOProvider>().fetchTodos();
              popScreen();
            },
            icon: Icon(
              Icons.check,
              color: white,
              size: height * 0.04,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _dialogBuilder(context, todoController),
        child: Icon(
          Icons.add,
          color: white,
          size: height * 0.03,
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.03, vertical: height * 0.02),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                cursorColor: textFieldCursorColor,
                style: textTheme.displaySmall,
                decoration: InputDecoration(
                  hintText: 'Add Todo Title',
                  hintStyle:
                      textTheme.displaySmall!.copyWith(color: greyShade300),
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
              Consumer<TODOProvider>(builder: (context, todoProvider, child) {
                if (todoProvider.todosChecklist.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'Add New Todo',
                        style: textTheme.bodyMedium!.copyWith(color: white),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                    itemCount: todoProvider.todosChecklist.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Todos currentTodo = todoProvider.todosChecklist[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: height * 0.01),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Todos todo = Todos(
                                    todo: currentTodo.todo,
                                    todoDone: !currentTodo.todoDone,
                                    todoID: currentTodo.todoID);
                                context
                                    .read<TODOProvider>()
                                    .updateTodosChecklist(index, todo);
                              },
                              child: Container(
                                height: height * 0.03,
                                width: height * 0.03,
                                decoration: BoxDecoration(
                                  border: Border.all(color: white),
                                ),
                                child: Icon(Icons.check,
                                    color: currentTodo.todoDone
                                        ? white
                                        : transparent),
                              ),
                            ),
                            CommonFunctions.blankSpace(
                              context: context,
                              reqHeight: 0,
                              reqWidth: 0.02,
                            ),
                            Text(
                              currentTodo.todo,
                              style: textTheme.bodyMedium!.copyWith(
                                color: white,
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                                onTap: () {
                                  context
                                      .read<TODOProvider>()
                                      .deleteTodosFromChecklist(index);
                                },
                                child: const Icon(Icons.close, color: white)),
                          ],
                        ),
                      );
                    });
              })
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _dialogBuilder(
    BuildContext context, TextEditingController todoController) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      final textTheme = Theme.of(context).textTheme;
      final height = MediaQuery.of(context).size.height;
      final width = MediaQuery.of(context).size.width;
      return AlertDialog(
        title: const Center(child: Text('Add Todo')),
        content: TextField(
          controller: todoController,
          cursorColor: black,
          style: textTheme.displaySmall!.copyWith(color: black),
          minLines: 3,
          maxLines: 7,
          decoration: InputDecoration(
            // hintText: 'Add Todo Title',
            hintStyle: textTheme.displaySmall!.copyWith(color: greyShade300),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: paleYellow,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: paleYellow,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: paleYellow,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: amber,
              ),
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Uuid uuid = Uuid();
                    Todos todo = Todos(
                        todo: todoController.text.trim(),
                        todoDone: false,
                        todoID: uuid.v1());
                    context.read<TODOProvider>().addTodoToChecklist(todo: todo);
                    todoController.clear();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(width * 0.5, height * 0.06)),
                  child: Text(
                    'Add',
                    style: textTheme.bodyMedium!.copyWith(color: white),
                  )),
            ],
          )
        ],
      );
    },
  );
}
