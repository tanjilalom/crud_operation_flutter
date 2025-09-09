import 'package:crud_operation_flutter/models/user_model.dart';
import 'package:hive/hive.dart';

class UserService {
  static const String _boxName = 'users';

  // Get the Hive box
  Box<User> get _box => Hive.box<User>(_boxName);

  // Initialize Hive box
  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<User>(_boxName);
    }
  }

  // Get all users
  Future<List<User>> getAllUsers() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _box.values.toList();
  }

  // Add new user
  Future<bool> addUser(User user) async {
    try {
      await _box.put(user.id, user);
      return true;
    } catch (e) {
      print('Error adding user: $e');
      return false;
    }
  }

  // Update existing user
  Future<bool> updateUser(User user) async {
    try {
      if (_box.containsKey(user.id)) {
        await _box.put(user.id, user);
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  // Delete user
  Future<bool> deleteUser(String id) async {
    try {
      if (_box.containsKey(id)) {
        await _box.delete(id);
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }

  // // Get user by ID
  // Future<User?> getUserById(String id) async {
  //   try {
  //     return _box.get(id);
  //   } catch (e) {
  //     print('Error getting user by ID: $e');
  //     return null;
  //   }
  // }
  //
  // // Get total user count
  // int getUserCount() {
  //   return _box.length;
  // }
  //
  // // Clear all users (useful for testing)
  // Future<void> clearAllUsers() async {
  //   await _box.clear();
  // }
}
