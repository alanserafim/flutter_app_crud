import 'package:flutter/material.dart';
import 'package:flutter_app_crud/provider/users.dart';
import 'package:flutter_app_crud/routes/app_routes.dart';
import 'package:flutter_app_crud/views/user_form.dart';
import 'package:flutter_app_crud/views/user_list.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Users(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          AppRoutes.HOME : (_) => UserList(),
          AppRoutes.USER_FORM : (_) => UserForm(),
        },
      ),
    );
  }
}
