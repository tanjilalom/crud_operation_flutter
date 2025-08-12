import '../models/user_model.dart';

class UserService {
  // Simulating a database with a static list
  static final List<User> _users = [


  ];

  // Get all users
  Future<List<User>> getAllUsers() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_users);
  }

  // Add new user
  Future<bool> addUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _users.add(user);
    return true;
  }

  // Update existing user
  Future<bool> updateUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 300));
    int index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
      return true;
    }
    return false;
  }

  // Delete user
  Future<bool> deleteUser(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _users.removeWhere((user) => user.id == id);
    return true;
  }

  // Get user by ID
  Future<User?> getUserById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }
}