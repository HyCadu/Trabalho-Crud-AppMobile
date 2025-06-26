import 'package:flutter/material.dart';
import '../models/jogo.dart';
import '../services/api_service.dart';

class EditarJogoScreen extends StatefulWidget {
  final Jogo jogo;
  const EditarJogoScreen({super.key, required this.jogo});

  @override
  _EditarJogoScreenState createState() => _EditarJogoScreenState();
}

class _EditarJogoScreenState extends State<EditarJogoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _scoreController;
  late TextEditingController _correctController;
  late TextEditingController _incorrectController;

  @override
  void initState() {
    super.initState();
    _scoreController = TextEditingController(
      text: widget.jogo.score?.toString() ?? '0',
    );
    _correctController = TextEditingController(
      text: widget.jogo.correctAnswers?.toString() ?? '0',
    );
    _incorrectController = TextEditingController(
      text: widget.jogo.incorrectAnswers?.toString() ?? '0',
    );
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _correctController.dispose();
    _incorrectController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        Jogo jogoEditado = Jogo(
          id: widget.jogo.id,
          userId: widget.jogo.userId,
          topics: widget.jogo.topics,
          score: double.tryParse(_scoreController.text) ?? 0,
          correctAnswers: int.tryParse(_correctController.text) ?? 0,
          incorrectAnswers: int.tryParse(_incorrectController.text) ?? 0,
        );
        await ApiService.updateResultadoJogo(widget.jogo.id!, jogoEditado);
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar o resultado o jogo')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Resultado do Jogo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _scoreController,
                decoration: const InputDecoration(labelText: 'Pontuação'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a pontuação';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _correctController,
                decoration: const InputDecoration(
                  labelText: 'Respostas Corretas',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o número de respostas corretas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _incorrectController,
                decoration: const InputDecoration(
                  labelText: 'Respostas Incorretas',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o número de respostas incorretas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
