import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/user_controller.dart';
import 'views/user_list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());

    return GetMaterialApp(
      title: 'Flutter CRUD Demo',
      home: UserListView(),
    );
  }
}
