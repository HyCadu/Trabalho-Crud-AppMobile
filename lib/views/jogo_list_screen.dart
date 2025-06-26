import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/jogo.dart';
import '../services/api_service.dart';
import 'add_jogo_screen.dart';
import 'editar_jogo_screen.dart';

class JogoListScreen extends StatefulWidget {
  final Player player;
  const JogoListScreen({super.key, required this.player});

  @override
  _JogoListScreenState createState() => _JogoListScreenState();
}

class _JogoListScreenState extends State<JogoListScreen> {
  late Future<List<Jogo>> futureJogos;

  @override
  void initState() {
    super.initState();
    _refreshJogos();
  }

  void _refreshJogos() {
    setState(() {
      futureJogos = ApiService.getJogosDoPlayer(widget.player.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, String> topicsMap = {
      1: 'Adição',
      2: 'Subtração',
      3: 'Multiplicação',
      4: 'Divisão',
    };
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogos de ${widget.player.name}'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshJogos),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddJogoScreen(playerId: widget.player.id!),
            ),
          );
          _refreshJogos();
        },
      ), //botao de adicionar jogo
      body: FutureBuilder<List<Jogo>>(
        future: futureJogos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum jogo encontrado'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Jogo jogo = snapshot.data![index];
              String topicosNomes = (jogo.topics as List)
                  .map((t) => topicsMap[t] ?? t.toString())
                  .join(', ');
              return ListTile(
                title: Text('Jogo ID: ${jogo.id}'),
                subtitle: Text(
                  'Pontuação: ${jogo.score ?? 0} - Tópicos: $topicosNomes',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditarJogoScreen(jogo: jogo),
                      ),
                    );
                    _refreshJogos();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
