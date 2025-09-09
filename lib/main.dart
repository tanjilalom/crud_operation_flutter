import 'package:crud_operation_flutter/models/user_model.dart';
import 'package:crud_operation_flutter/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'controllers/user_controller.dart';
import 'views/user_list_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());

  final userService = UserService();
  await userService.init();

  Get.put(userService);
  Get.put(UserController());

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
