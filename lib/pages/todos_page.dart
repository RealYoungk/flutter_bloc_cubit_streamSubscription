import 'package:flutter/material.dart';
import 'package:todo_cubit/pages/create_todo.dart';
import 'package:todo_cubit/pages/search_and_filter_todo.dart';
import 'package:todo_cubit/pages/show_todos.dart';
import 'package:todo_cubit/pages/todo_header.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              children: [
                TodoHeader(),
                CreateTodo(),
                SizedBox(height: 20),
                SearchAndFilterTodo(),
                ShowTodos(),
              ]
            ),
          ),
        ),
      ),
    );
  }
}
