import 'package:flutter/material.dart';
import 'package:flutter_app_crud/components/user_tile.dart';
import 'package:flutter_app_crud/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../provider/users.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  late Future<void> _loadUsers;

  @override
  void initState() {
    super.initState();
    _loadUsers = _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final usersProvider = Provider.of<Users>(context, listen: false);
    await usersProvider.all; // Chamando o método all para buscar os dados
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Usuários", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
              icon: Icon(Icons.add_circle_outline, color: Colors.white),
              onPressed: (){
                Navigator.of(context).pushNamed(
                    AppRoutes.USER_FORM,
                );
              },
          )
        ],
      ),
      body: FutureBuilder(
        future: _loadUsers,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return Center(child: Text("Ocorreu um erro ao carregar os usuários."));
          } else {
            return Consumer<Users>(
              builder: (ctx, users, _) => ListView.builder(
                itemCount: users.count,
                itemBuilder: (ctx, i) => UserTile(users.byIndex(i)),
              ),
            );
          }
        },
      ),
    );
  }
}