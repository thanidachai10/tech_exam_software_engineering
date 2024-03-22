import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../model/todo_model.dart';

class TodoController extends GetxController {
  var todos = <ToDoModel>[].obs;
  var searchResults = <ToDoModel>[].obs;
  final hasSearched = false.obs;

  TextEditingController searchController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  @override
  void onInit() {
    loadTodos();
    super.onInit();
  }

  loadTodos() {
    final box = GetStorage();
    if (box.hasData('todos')) {
      final List<dynamic> jsonTodos = box.read<List<dynamic>>('todos')!;
      final List<ToDoModel> loadedTodos =
          jsonTodos.map((json) => ToDoModel.fromJson(json)).toList();
      loadedTodos.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      todos.assignAll(loadedTodos);
    }
  }

  void addTodo(ToDoModel todo) {
    todos.add(todo);

    titleController.clear();
    descriptionController.clear();
    dateController.clear();
    statusController.clear();
    imageController.clear();

    saveTodos();
    loadTodos();

    Get.back();

    Fluttertoast.showToast(
      msg: 'Add ToDo Successful!',
      backgroundColor: Colors.green[600],
    );
  }

  void removeTodo(String id) {
    todos.removeWhere((todo) => todo.id == id);

    titleController.clear();
    descriptionController.clear();
    dateController.clear();
    statusController.clear();
    imageController.clear();

    saveTodos();
    updateSearchResults(id);

    Get.back();

    Fluttertoast.showToast(
      msg: 'Delete ToDo Successful!',
      backgroundColor: Colors.green[600],
    );
  }

  void updateTodo(String id, String? newTitle, String? newDescription,
      DateTime? newDate, String? newImage, String? newStatus) {
    final index = todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      if (newTitle != null) {
        todos[index].title = newTitle;
      }
      if (newDescription != null) {
        todos[index].description = newDescription;
      }
      if (newDate != null) {
        todos[index].createdAt = newDate;
      }
      if (newImage != null) {
        todos[index].image = newImage;
      }
      if (newStatus != null) {
        todos[index].status = newStatus;
      }
      saveTodos();

      Fluttertoast.showToast(
        msg: 'Update ToDo Successful!',
        backgroundColor: Colors.green[600],
      );

      loadTodos();
      Get.back();
    }
  }

  saveTodos() {
    final box = GetStorage();
    box.write('todos', todos.map((todo) => todo.toJson()).toList());
  }

  void search(String query) {
    hasSearched.value = true;
    if (query.isEmpty) {
      searchResults.assignAll(todos);
    } else {
      final result = todos
          .where((todo) =>
              todo.title!.toLowerCase().contains(query.toLowerCase()) ||
              todo.description!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      searchResults.assignAll(result);
    }
  }

  void updateSearchResults(String id) {
    searchResults.removeWhere((todo) => todo.id == id);
  }

  void sortByStatus(String status) {
    todos.sort((a, b) {
      if (a.status == status && b.status != status) {
        return -1;
      } else if (a.status != status && b.status == status) {
        return 1;
      } else {
        return 0;
      }
    });
  }

  void sortByDateCreated() {
    todos.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
  }
}
