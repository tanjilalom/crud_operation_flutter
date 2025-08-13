import 'package:crud_operation_flutter/models/user_model.dart';
import 'package:crud_operation_flutter/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserService _userService = UserService();

  var users = <User>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  /// Load all users
  Future<void> loadUsers() async {
    isLoading.value = true;
    try {
      users.value = await _userService.getAllUsers();
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Failed to load users: $e';
      _showSnackbar('Error', 'Failed to load users', Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  /// Add new user
  Future<bool> addUser({
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      String newId = DateTime.now().millisecondsSinceEpoch.toString();
      User newUser = User(id: newId, name: name, email: email, phone: phone);

      bool success = await _userService.addUser(newUser);
      if (success) {
        users.add(newUser);
        _showSnackbar('Success', 'User added successfully', Colors.green);
        return true;
      }
      return false;
    } catch (e) {
      _showSnackbar('Error', 'Failed to add user: $e', Colors.red);
      return false;
    }
  }

  /// Update existing user
  Future<bool> updateUser({
    required String id,
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      User updatedUser = User(id: id, name: name, email: email, phone: phone);

      bool success = await _userService.updateUser(updatedUser);
      if (success) {
        int index = users.indexWhere((u) => u.id == id);
        if (index != -1) {
          users[index] = updatedUser;
        }
        _showSnackbar('Success', 'User updated successfully', Colors.green);
        return true;
      }
      return false;
    } catch (e) {
      _showSnackbar('Error', 'Failed to update user: $e', Colors.red);
      return false;
    }
  }

  /// Delete user
  Future<bool> deleteUser(String id) async {
    try {
      bool success = await _userService.deleteUser(id);
      if (success) {
        users.removeWhere((user) => user.id == id);
        _showSnackbar('Success', 'User deleted successfully', Colors.green);
        return true;
      }
      return false;
    } catch (e) {
      _showSnackbar('Error', 'Failed to delete user: $e', Colors.red);
      return false;
    }
  }

  /// Helper for snackbars
  void _showSnackbar(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color.withOpacity(0.8),
      colorText: Colors.white,
      margin: const EdgeInsets.all(8),
    );
  }
}
