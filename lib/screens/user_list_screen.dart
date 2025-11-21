import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickensol_task/screens/login_screen.dart';
import 'package:quickensol_task/utils/app_colors.dart';
import 'package:quickensol_task/widgets/custom_button.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_toast.dart';
import '../widgets/custom_textFormField.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "User Manager",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await auth.logout();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>LoginScreen()));
            },
            icon: const Icon(Icons.logout, color: Colors.black),
          ),
        ],
      ),
      body: userProvider.loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: () async => await userProvider.fetchUsers(),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: userProvider.users.length,
          itemBuilder: (context, index) {
            final u = userProvider.users[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 14),

                title: Text(
                  u.name,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600,),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        u.email,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 12),
                      ), Text(
                        u.phoneNumber,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _iconButton(
                      icon: Icons.edit,
                      color: Colors.blue,
                      onTap: () => _openEditDialog(context, userProvider, u),
                    ),
                    const SizedBox(width: 6),
                    _iconButton(
                      icon: Icons.delete,
                      color: Colors.redAccent,
                      onTap: () => _deleteUser(context, userProvider, u.id!),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),


    );
  }

  Widget _iconButton({
    required IconData icon,
    required Color color,
    required Function onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }


  void _openEditDialog(BuildContext context, UserProvider prov, user) {
    final name = TextEditingController(text: user.name);
    final email = TextEditingController(text: user.email);
    final phone = TextEditingController(text: user.phoneNumber);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: AppColors.backgroundColor,
          title: const Text(
            "Edit User",
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name
                CustomTextField(
                  controller: name,
                  hint: "Name",
                  prefixIcon: Icons.email,
                ),

                const SizedBox(height: 12),

                // Email
                CustomTextField(
                  controller: email,
                  hint: "Email",
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: 12),

                // Phone
                CustomTextField(
                  controller: phone,
                  hint: "Phone Number",
                  prefixIcon: Icons.email,
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            CustomButton(title: 'Save', onTap: () async {
            if (name.text.trim().isEmpty ||
            email.text.trim().isEmpty ||
            phone.text.trim().isEmpty) {
            AppToast.show("Please fill all fields");
            return;
            }

            if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                .hasMatch(email.text.trim())) {
            AppToast.show("Enter a valid email");
            return;
            }

            if (phone.text.trim().length < 10) {
            AppToast.show("Enter a valid phone number");
            return;
            }

            // API Update Call
            final updatedUser = UserModel(
            id: user.id,
            name: name.text.trim(),
            email: email.text.trim(),
            phoneNumber: phone.text.trim(),
            password: user.password,
            );

            await prov.updateUser(updatedUser);

            AppToast.show("User updated successfully");

            Navigator.pop(context, updatedUser);
            },),

          ],
        );
      },
    );
  }

  Future<void> _deleteUser(
      BuildContext context, UserProvider userProvider, String id) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.backgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18)),
        title: const Text("Confirm Delete?"),
        content: const Text("Do you really want to delete this user?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete",style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await userProvider.deleteUser(id);
      AppToast.show("User Deleted");
    }
  }
}
