import 'package:flutter/material.dart';
import '../../../shared/models/todo.dart';
import 'todo_item_widget.dart';

class TodoListWidget extends StatefulWidget {
  final List<Todo> todos;
  final Function(String) onTodoToggled;
  final Function(Todo) onTodoUpdated;
  final Function(String) onTodoDeleted;

  const TodoListWidget({
    super.key,
    required this.todos,
    required this.onTodoToggled,
    required this.onTodoUpdated,
    required this.onTodoDeleted,
  });

  @override
  State<TodoListWidget> createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.todos.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      itemCount: widget.todos.length,
      itemBuilder: (context, index) {
        final todo = widget.todos[index];
        return TodoItemWidget(
          key: ValueKey(todo.id), // Important for performance
          todo: todo,
          onToggled: () => widget.onTodoToggled(todo.id),
          onUpdated: widget.onTodoUpdated,
          onDeleted: () => widget.onTodoDeleted(todo.id),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No todos yet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Add a new todo to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}