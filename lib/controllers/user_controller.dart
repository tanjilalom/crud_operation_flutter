import 'package:crud_operation_flutter/models/user_model.dart';
import 'package:crud_operation_flutter/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserService _userService = Get.find<UserService>();

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
    isLoading.value = true;
    try {
      String newId = DateTime.now().millisecondsSinceEpoch.toString();
      User newUser = User(id: newId, name: name, email: email, phone: phone);

      bool success = await _userService.addUser(newUser);
      if (success) {
        // Reload users to get fresh data from Hive
        await loadUsers();
        _showSnackbar('Success', 'User added successfully', Colors.green);
        return true;
      }
      return false;
    } catch (e) {
      _showSnackbar('Error', 'Failed to add user: $e', Colors.red);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update existing user
  Future<bool> updateUser({
    required String id,
    required String name,
    required String email,
    required String phone,
  }) async {
    isLoading.value = true;
    try {
      User updatedUser = User(id: id, name: name, email: email, phone: phone);

      bool success = await _userService.updateUser(updatedUser);
      if (success) {
        // Reload users to get fresh data from Hive
        await loadUsers();
        _showSnackbar('Success', 'User updated successfully', Colors.green);
        return true;
      }
      return false;
    } catch (e) {
      _showSnackbar('Error', 'Failed to update user: $e', Colors.red);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete user with confirmation
  Future<void> deleteUser(String id) async {
    // Show confirmation dialog
    bool? confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete User'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      isLoading.value = true;
      try {
        bool success = await _userService.deleteUser(id);
        if (success) {
          // Reload users to get fresh data from Hive
          await loadUsers();
          _showSnackbar('Success', 'User deleted successfully', Colors.green);
        }
      } catch (e) {
        _showSnackbar('Error', 'Failed to delete user: $e', Colors.red);
      } finally {
        isLoading.value = false;
      }
    }
  }

  /// Get user count
  // int getUserCount() {
  //   return _userService.getUserCount();
  // }

  /// Clear all users (for testing)
  Future<void> clearAllUsers() async {
    bool? confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Clear All Users'),
        content: const Text('This will delete all users. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child:
                const Text('Clear All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // await _userService.clearAllUsers();
      await loadUsers();
      _showSnackbar('Success', 'All users cleared', Colors.orange);
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
      duration: const Duration(seconds: 2),
    );
  }
}
