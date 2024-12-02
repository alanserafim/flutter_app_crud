import 'package:flutter/material.dart';
import 'package:flutter_app_crud/components/user_tile.dart';
import 'package:flutter_app_crud/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../provider/users.dart';

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    final Users users = Provider.of(
        context,
        //listen: false
    );
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
      body: ListView.builder(
          itemCount: users.count,
          itemBuilder: (ctx, i ) => UserTile(users.byIndex(i)),
      ),
    );
  }
}
