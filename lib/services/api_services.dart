import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';


class ApiService {
  static const String baseUrl = "https://6920a31231e684d7bfcdbd96.mockapi.io/v1/";

  Future<List<UserModel>> getUsers() async {
    final http.Response res = await http.get(Uri.parse("$baseUrl/userList"));
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((e) => UserModel.fromJson(e)).toList();
    }
    throw Exception("Failed to fetch users");
  }


  Future<UserModel> createUser(UserModel user) async {
    final http.Response  res = await http.post(
      Uri.parse("$baseUrl/userList"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );
    if (res.statusCode == 201) {
      return UserModel.fromJson(jsonDecode(res.body));
    }
    throw Exception("Failed to create user");
  }


  Future<void> deleteUser(String id) async {
    await http.delete(Uri.parse("$baseUrl/userList/$id"));
  }


  Future<UserModel> updateUser(UserModel user) async {
    final http.Response res = await http.put(
      Uri.parse("$baseUrl/userList/${user.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );
    return UserModel.fromJson(jsonDecode(res.body));
  }
}