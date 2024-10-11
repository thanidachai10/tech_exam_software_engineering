import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../controller/todo_controller.dart';
import '../../model/todo_model.dart';
import '../../utils/common.dart';

class AddToDoScreen extends StatefulWidget {
  const AddToDoScreen({super.key});

  @override
  State<AddToDoScreen> createState() => _AddToDoScreenState();
}

class _AddToDoScreenState extends State<AddToDoScreen> {
  final GlobalKey<FormState> _todoFormKey = GlobalKey<FormState>();
  TodoController todoController = Get.find();
  TodoStatus _selectedStatus = TodoStatus.inProgress;

  String? _pickedImagePath;
  String? _base64Image;

  final FocusNode _titleFocus = FocusNode();
  bool _titleValidator(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _pickedImagePath = pickedImage.path;
        _base64Image = base64Encode(File(_pickedImagePath!).readAsBytesSync());
      });
    }
  }

  @override
  void initState() {
    //clear todoController ให้เป็นค่าว่างตอนเข้ามาเพิ่ม
    todoController.titleController.clear();
    todoController.descriptionController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text(
          'Add ToDo',
          style: GoogleFonts.prompt(),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _todoFormKey,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedStatus = TodoStatus.inProgress;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    _selectedStatus == TodoStatus.inProgress
                                        ? Colors.green
                                        : null,
                              ),
                              child: Text(
                                'In Progress',
                                style: GoogleFonts.prompt(
                                  fontSize: 14,
                                  color:
                                      _selectedStatus == TodoStatus.inProgress
                                          ? Colors.white
                                          : null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedStatus = TodoStatus.completed;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    _selectedStatus == TodoStatus.completed
                                        ? Colors.blue
                                        : null,
                              ),
                              child: Text(
                                'Completed',
                                style: GoogleFonts.prompt(
                                  fontSize: 14,
                                  color: _selectedStatus == TodoStatus.completed
                                      ? Colors.white
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        TextFormField(
                          focusNode: _titleFocus,
                          controller: todoController.titleController,
                          decoration: InputDecoration(
                            hintText: 'Title',
                            hintStyle: GoogleFonts.prompt(
                              fontSize: 16.0,
                            ),
                            labelStyle: GoogleFonts.prompt(
                              fontSize: 16.0,
                            ),
                            fillColor: Colors.green[1000],
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            final isValid = _titleValidator(value);
                            if (!isValid) {
                              return 'กรุณากรอก';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        TextFormField(
                          maxLines: 5,
                          controller: todoController.descriptionController,
                          decoration: InputDecoration(
                            hintText: 'Description',
                            hintStyle: GoogleFonts.prompt(
                              fontSize: 16.0,
                            ),
                            labelStyle: GoogleFonts.prompt(
                              fontSize: 16.0,
                            ),
                            fillColor: Colors.green[1000],
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              backgroundColor: theme.colorScheme.tertiary,
                            ),
                            onPressed: () {
                              _pickImage();
                            },
                            child: Text(
                              'Pick Image',
                              style: GoogleFonts.prompt(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        if (_pickedImagePath != null) ...[
                          const SizedBox(height: 16),
                          Stack(
                            children: [
                              Image.file(
                                File(_pickedImagePath!),
                                height: 250,
                                width: 250,
                                fit: BoxFit.cover,
                              ),
                              // วงกลม
                              Positioned(
                                top: 0,
                                right: 8,
                                child: CircleAvatar(
                                  backgroundColor: theme.colorScheme.error,
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _pickedImagePath = null;
                                      });
                                    },
                                    icon: const Icon(Icons.delete),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: theme.colorScheme.primary,
                    ),
                    onPressed: () {
                      if (_todoFormKey.currentState!.validate()) {
                        if (_selectedStatus != TodoStatus.inProgress &&
                            _selectedStatus != TodoStatus.completed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Invalid status selection',
                                style: GoogleFonts.prompt(fontSize: 16.0),
                              ),
                            ),
                          );
                          return;
                        }

                        if (_pickedImagePath == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please select an image',
                                style: GoogleFonts.prompt(fontSize: 16.0),
                              ),
                            ),
                          );
                          return;
                        }

                        if (!_titleValidator(
                            todoController.titleController.text)) {
                          _titleFocus.requestFocus();
                        }

                        ToDoModel todo = ToDoModel(
                          id: const Uuid().v4(),
                          title: todoController.titleController.text,
                          createdAt: DateTime.now().toUtc(),
                          image: _base64Image.toString(),
                          status: _selectedStatus.toString(),
                          description:
                              todoController.descriptionController.text,
                        );

                        todoController.addTodo(todo);
                      }
                    },
                    child: Text(
                      'Add ToDo',
                      style: GoogleFonts.prompt(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
