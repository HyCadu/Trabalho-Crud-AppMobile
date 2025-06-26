import 'package:flutter/material.dart';
import '../models/player.dart';
import '../services/api_service.dart';

class AddPlayerScreen extends StatefulWidget {
  const AddPlayerScreen({super.key});

  @override
  _AddPlayerScreenState createState() => _AddPlayerScreenState();
}

class _AddPlayerScreenState extends State<AddPlayerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2015, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime(2019, 12, 31),
    );
    if (picked != null && picked != _selectedDate) {
      if (picked.isAfter(DateTime(2019, 12, 31))) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Usuários devem ter mais de 6 anos (nascidos até 31/12/2019).',
            ),
          ),
        );
        return;
      }
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, selecione a data de nascimento'),
          ),
        );
        return;
      }

      try {
        Player newPlayer = Player(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          dateOfBirth: _selectedDate!,
        );

        await ApiService.addPlayer(newPlayer);
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Player')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Por favor, insira um email válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText:
                      'Senha - Maiuscula, minuscula, numero e caracter especial',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma senha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Nenhuma data selecionada'
                          : '${_selectedDate?.toLocal()}',
                    ),
                  ),
                  TextButton(
                    onPressed: () => _pickDate(context),
                    child: const Text('Selecionar Data de Nascimento'),
                  ),
                ],
              ),
              Text('usuário deve ter mais de 6 anos'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
