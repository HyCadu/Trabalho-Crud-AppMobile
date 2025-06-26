import 'package:flutter/material.dart';
import '../models/player.dart';
import '../services/api_service.dart';
import 'add_player_screen.dart';
import 'jogo_list_screen.dart';
import 'editar_player_screen.dart';

class PlayerListScreen extends StatefulWidget {
  const PlayerListScreen({super.key});

  @override
  _PlayerListScreenState createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  late Future<List<Player>> futurePlayers;

  @override
  void initState() {
    super.initState();
    _refreshPlayers();
  }

  void _refreshPlayers() {
    setState(() {
      futurePlayers = ApiService.getPlayer();
    });
  }

  Future<void> _deletePlayer(String id) async {
    try {
      await ApiService.deletePlayer(id);
      _refreshPlayers();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Player excluído com sucesso')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir: ${e.toString()}')),
      );
    }
  }

  Future<void> _updatePlayer(String id, Player player) async {
    try {
      await ApiService.updatePlayer(id, player);
      _refreshPlayers();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Player atualizado com sucesso')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar: ${e.toString()}')),
      );
    }
  }

  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Tem certeza que deseja excluir este player?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deletePlayer(id);
              },
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Players'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshPlayers,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPlayerScreen()),
          );
          _refreshPlayers();
        },
      ),
      body: FutureBuilder<List<Player>>(
        future: futurePlayers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum player encontrado'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Player player = snapshot.data![index];
              return ListTile(
                title: Text(player.name),
                subtitle: Text(player.email),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JogoListScreen(player: player),
                    ),
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.deepPurple),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditarPlayerScreen(player: player),
                          ),
                        );
                        _refreshPlayers();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteDialog(player.id!),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
