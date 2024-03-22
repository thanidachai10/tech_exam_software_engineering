import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/todo_controller.dart';
import '../../utils/images_assets.dart';
import '../todo/add_todo_screen.dart';
import '../todo/todo_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TodoController todoController = Get.put(TodoController());

  bool scheduleSelected = false;
  bool inProgressSelected = false;
  bool completedSelected = false;

  Future<void> _refreshTodos() async {
    await todoController.loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text(
          'ToDo Application',
          style: GoogleFonts.prompt(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: 200,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Image.asset(
                            MyImagesAssetes.scheduleIcon,
                            width: 24,
                            height: 24,
                          ),
                          trailing: scheduleSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              : null,
                          title: Text(
                            'Date Created',
                            style: GoogleFonts.prompt(fontSize: 16),
                          ),
                          onTap: () {
                            setState(() {
                              scheduleSelected = true;
                              inProgressSelected = false;
                              completedSelected = false;
                            });
                            todoController.sortByDateCreated();
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: Image.asset(
                            MyImagesAssetes.inProgressIcon,
                            width: 24,
                            height: 24,
                          ),
                          trailing: inProgressSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              : null,
                          title: Text(
                            'Inprogress',
                            style: GoogleFonts.prompt(fontSize: 16),
                          ),
                          onTap: () {
                            setState(() {
                              scheduleSelected = false;
                              inProgressSelected = true;
                              completedSelected = false;
                            });
                            todoController
                                .sortByStatus('TodoStatus.inProgress');
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: Image.asset(
                            MyImagesAssetes.completeIcon,
                            width: 24,
                            height: 24,
                          ),
                          trailing: completedSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              : null,
                          title: Text(
                            'Complete',
                            style: GoogleFonts.prompt(
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              scheduleSelected = false;
                              inProgressSelected = false;
                              completedSelected = true;
                            });
                            todoController.sortByStatus('TodoStatus.completed');
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: Image.asset(
              MyImagesAssetes.sortIcon,
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        'สวัสดี\nThanida Supachat',
                        style: GoogleFonts.prompt(fontSize: 22),
                      )
                    ],
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          todoController.hasSearched.value = false;
                        } else {
                          todoController.search(value);
                        }
                      });
                    },
                    controller: todoController.searchController,
                    decoration: InputDecoration(
                      hintText: 'ค้นหา...',
                      hintStyle: GoogleFonts.prompt(
                        fontSize: 16.0,
                      ),
                      labelStyle: GoogleFonts.prompt(
                        fontSize: 16.0,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      fillColor: Colors.green[1000],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshTodos,
                child: Obx(
                  () {
                    final todos = todoController.todos;
                    final searchResults = todoController.searchResults;
                    final hasSearched = todoController.hasSearched;

                    if (!hasSearched.value) {
                      return todos.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    MyImagesAssetes.noteIcon,
                                    width: 136,
                                    height: 136,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'ไม่มีข้อมูล',
                                    style: GoogleFonts.prompt(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            )
                          : GridView.builder(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 0.0,
                                childAspectRatio: 1.0,
                              ),
                              itemCount: todos.length,
                              itemBuilder: (context, index) {
                                final todo = todos[index];
                                return InkWell(
                                  onTap: () {
                                    Get.to(
                                      () => ToDoDetailScreen(todo: todo),
                                    );
                                  },
                                  child: Card(
                                    child: ListTile(
                                      title: Text(
                                        todo.title!,
                                        style: GoogleFonts.prompt(
                                          fontSize: 16,
                                        ),
                                      ),
                                      subtitle: Text(
                                        todo.description!,
                                        style: GoogleFonts.prompt(
                                          fontSize: 12,
                                        ),
                                      ),
                                      leading: todo.status ==
                                              'TodoStatus.inProgress'
                                          ? Image.asset(
                                              MyImagesAssetes.inProgressIcon,
                                              width: 24,
                                              height: 24,
                                            )
                                          : Image.asset(
                                              MyImagesAssetes.completeIcon,
                                              width: 24,
                                              height: 24,
                                            ),
                                    ),
                                  ),
                                );
                              },
                            );
                    } else if (searchResults.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              MyImagesAssetes.noResultsIcon,
                              width: 136,
                              height: 136,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              'ไม่มีข้อมูลจากการค้นหา',
                              style: GoogleFonts.prompt(fontSize: 16.0),
                            ),
                          ],
                        ),
                      );
                    } else if (searchResults == todos) {
                      return GridView.builder(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 0.0,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          final todo = todos[index];
                          return InkWell(
                            onTap: () {
                              Get.to(
                                () => ToDoDetailScreen(todo: todo),
                              );
                            },
                            child: Card(
                              child: ListTile(
                                title: Text(
                                  todo.title!,
                                  style: GoogleFonts.prompt(
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  todo.description!,
                                  style: GoogleFonts.prompt(
                                    fontSize: 12,
                                  ),
                                ),
                                leading: todo.status == 'TodoStatus.inProgress'
                                    ? Image.asset(
                                        MyImagesAssetes.inProgressIcon,
                                        width: 24,
                                        height: 24,
                                      )
                                    : Image.asset(
                                        MyImagesAssetes.completeIcon,
                                        width: 24,
                                        height: 24,
                                      ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return GridView.builder(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 0.0,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final todo = searchResults[index];
                          return InkWell(
                            onTap: () {
                              Get.to(
                                () => ToDoDetailScreen(todo: todo),
                              );
                            },
                            child: Card(
                              child: ListTile(
                                title: Text(
                                  todo.title!,
                                  style: GoogleFonts.prompt(
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  todo.description!,
                                  style: GoogleFonts.prompt(
                                    fontSize: 12,
                                  ),
                                ),
                                leading: todo.status == 'TodoStatus.inProgress'
                                    ? Image.asset(
                                        MyImagesAssetes.inProgressIcon,
                                        width: 24,
                                        height: 24,
                                      )
                                    : Image.asset(
                                        MyImagesAssetes.completeIcon,
                                        width: 24,
                                        height: 24,
                                      ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // todoController.searchController.clear();
          await Get.to(() => const AddToDoScreen());
          todoController.titleController.clear();
          todoController.descriptionController.clear();
        },
        tooltip: 'Add ToDo',
        child: const Icon(Icons.add),
      ), // This tra
    );
  }
}
