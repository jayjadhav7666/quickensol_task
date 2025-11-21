import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_services.dart';


class UserProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  List<UserModel> users = [];
  bool loading = false;


  Future<void> fetchUsers() async {
    loading = true;
    notifyListeners();
    dynamic temp = await _api.getUsers();
    users = temp.reversed.toList();
    loading = false;
    notifyListeners();
  }


  Future<void> addUser(UserModel user) async {
    await _api.createUser(user);
    fetchUsers();
  }


  Future<void> updateUser(UserModel user) async {
    await _api.updateUser(user);
    fetchUsers();
  }


  Future<void> deleteUser(String id) async {
    await _api.deleteUser(id);
    fetchUsers();
  }
}