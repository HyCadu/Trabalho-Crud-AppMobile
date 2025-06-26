import 'package:flutter/material.dart';
import '../models/jogo.dart';
import '../services/api_service.dart';

class AddJogoScreen extends StatefulWidget {
  final String playerId;
  const AddJogoScreen({super.key, required this.playerId});

  @override
  _AddJogoScreenState createState() => _AddJogoScreenState();
}

class _AddJogoScreenState extends State<AddJogoScreen> {
  final _formKey = GlobalKey<FormState>();
  int _difficulty = 0;
  final Map<int, String> _topicsOptions = {
    1: 'Adição',
    2: 'Subtração',
    3: 'Multiplicação',
    4: 'Divisão',
  };
  final Set<int> _selectedTopics = {};

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final topics = _selectedTopics.toList();

        if (topics.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Por favor, selecione pelo menos um tópico'),
            ),
          );
          return;
        }

        Jogo newJogo = Jogo(
          userId: widget.playerId,
          topics: topics,
          difficulty: _difficulty,
        );

        await ApiService.addJogo(newJogo);
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar o jogo: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Jogo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('Tópicos:'),
              ..._topicsOptions.entries.map(
                (entry) => CheckboxListTile(
                  title: Text('${entry.key} - ${entry.value}'),
                  value: _selectedTopics.contains(entry.key),
                  onChanged: (bool? selected) {
                    setState(() {
                      if (selected == true) {
                        _selectedTopics.add(entry.key);
                      } else {
                        _selectedTopics.remove(entry.key);
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: _difficulty,
                decoration: const InputDecoration(labelText: 'Dificuldade'),
                items: const [
                  DropdownMenuItem(value: 0, child: Text('0 - Não definido')),
                  DropdownMenuItem(value: 1, child: Text('1 - Fácil')),
                  DropdownMenuItem(value: 2, child: Text('2 - Médio')),
                  DropdownMenuItem(value: 3, child: Text('3 - Difícil')),
                ],
                onChanged: (value) {
                  setState(() {
                    _difficulty = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Salvar Jogo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
