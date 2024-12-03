import 'package:flutter/material.dart';
import 'package:flutter_app_crud/provider/users.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;

  final Map<String, String> _formData = {};

  void _loadFormData(User user) {
      _formData['id'] = user.id;
      _formData['name'] = user.name;
      _formData['email'] = user.email;
      _formData['avatarUrl'] = user.avatarUrl;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = ModalRoute.of(context)?.settings.arguments as User?;
    if (user != null) {
      _loadFormData(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Formulário de Usuário",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            onPressed: () async {
              final isValid = _form.currentState?.validate() ?? false;
              if (isValid) {
                _form.currentState?.save();
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<Users>(context, listen: false).put(
                  User(
                    id: _formData['id'] ?? "",
                    name: _formData['name'] ?? "",
                    email: _formData['email'] ?? "",
                    avatarUrl: _formData['avatarUrl'] ?? "",
                  ),
                );
                setState(() {
                  _isLoading = false;
                });
                Navigator.of(context).pop();
              }
            },
            icon: Icon(Icons.save, color: Colors.white),
          ),
        ],
      ),
      body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                initialValue: _formData['name'],
                decoration: InputDecoration(labelText: "Nome"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Nome inválido";
                  }
                  if (value.trim().length < 3) {
                    return "Nome muito pequeno. Deve ter no minímo 3 letras";
                  }
                  return null;
                },
                onSaved: (value) => _formData['name'] = value ?? "",
              ),
              TextFormField(
                initialValue: _formData['email'],
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Email inválido";
                  }
                  return null;
                },
                onSaved: (value) => _formData['email'] = value ?? "",
              ),
              TextFormField(
                initialValue: _formData['avatarUrl'],
                decoration: InputDecoration(labelText: "URL do Avatar"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "URL inválida";
                  }
                  return null;
                },
                onSaved: (value) => _formData['avatarUrl'] = value ?? "",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
