import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit/cubits/cubits.dart';

import '../models/todo_model.dart';

class ShowTodos extends StatelessWidget {
  const ShowTodos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<FilteredTodosCubit>().state.filteredTodos;

    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return Dismissible(
            key: ValueKey(todos[index].id),
            background: showBackground(0),
            secondaryBackground: showBackground(1),
            onDismissed: (_) {
              context.read<TodoListCubit>().removeTodo(todos[index]);
            },
            confirmDismiss: (_) {
              return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Are you sure?'),
                      content: Text('Do you really want to delete?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('NO'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('YES'),
                        ),
                      ],
                    );
                  });
            },
            child: TodoItem(todo: todos[index]));
      },
      separatorBuilder: (context, index) {
        return Divider(color: Colors.grey);
      },
    );
  }

  Widget showBackground(int direction) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      color: Colors.red,
      alignment: direction == 0 ? Alignment.centerLeft : Alignment.centerRight,
      child: const Icon(Icons.delete, size: 30, color: Colors.white),
    );
  }
}

class TodoItem extends StatefulWidget {
  final Todo todo;

  @override
  State<TodoItem> createState() => _TodoItemState();

  const TodoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);
}

class _TodoItemState extends State<TodoItem> {
  late final TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            bool _error = false;
            textEditingController.text = widget.todo.desc;
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Text('Edit Todo'),
                  content: TextField(
                    controller: textEditingController,
                    autofocus: true,
                    decoration: InputDecoration(
                      errorText: _error ? 'Value cannot be empty' : null,
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('CANCEL')),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _error = textEditingController.text.isEmpty
                                ? true
                                : false;
                            if (!_error) {
                              context.read<TodoListCubit>().editTodo(
                                  widget.todo.id, textEditingController.text);
                              Navigator.pop(context);
                            }
                          });
                        },
                        child: Text('EDIT')),
                  ],
                );
              },
            );
          },
        );
      },
      leading: Checkbox(
        value: widget.todo.completed,
        onChanged: (bool? checked) {
          context.read<TodoListCubit>().toggleTodo(widget.todo.id);
        },
      ),
      title: Text(widget.todo.desc),
    );
  }
}
