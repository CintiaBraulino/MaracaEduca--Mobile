import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_map_app/providers/auth_provider.dart';
import 'package:school_map_app/providers/school_provider.dart';
import 'package:school_map_app/screens/school_detail_screen.dart';
import 'package:school_map_app/screens/map_screen.dart';
import 'package:school_map_app/screens/auth_screen.dart';

class SchoolsListScreen extends StatefulWidget {
  static const routeName = '/schools-list';
  const SchoolsListScreen({super.key});

  @override
  State<SchoolsListScreen> createState() => _SchoolsListScreenState();
}

class _SchoolsListScreenState extends State<SchoolsListScreen> {
  @override
  void initState() {
    super.initState();
    // Busca as escolas ao carregar a tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SchoolProvider>(context, listen: false).fetchSchools();
    });
  }

  Future<void> _refreshSchools(BuildContext context) async {
    await Provider.of<SchoolProvider>(context, listen: false).fetchSchools();
  }

  void _confirmAndDeleteSchool(BuildContext context, String schoolId, String schoolName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja excluir a escola "$schoolName"?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              Navigator.of(ctx).pop(); // Fecha o dialog
              final success = await Provider.of<SchoolProvider>(context, listen: false).deleteSchool(schoolId);
              if (!success) {
                // Exibir mensagem de erro se a exclusão falhar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Falha ao excluir escola.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolas Públicas'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.of(context).pushNamed(MapScreen.routeName);
            },
            tooltip: 'Ver no Mapa',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(SchoolDetailScreen.routeName);
            },
            tooltip: 'Adicionar Escola',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
              }
            },
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Consumer<SchoolProvider>(
        builder: (context, schoolProvider, child) {
          if (schoolProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (schoolProvider.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      schoolProvider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => _refreshSchools(context),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (schoolProvider.schools.isEmpty) {
            return const Center(
              child: Text(
                'Nenhuma escola cadastrada ainda. Adicione uma!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => _refreshSchools(context),
            child: ListView.builder(
              itemCount: schoolProvider.schools.length,
              itemBuilder: (ctx, i) {
                final school = schoolProvider.schools[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        school.name[0],
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      school.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(school.address),
                        Text('Alunos: ${school.numberOfStudents}'),
                        Text('Lat: ${school.latitude.toStringAsFixed(4)}, Long: ${school.longitude.toStringAsFixed(4)}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              SchoolDetailScreen.routeName,
                              arguments: school.id, // Passa o ID da escola para edição
                            );
                          },
                          tooltip: 'Editar Escola',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmAndDeleteSchool(context, school.id!, school.name),
                          tooltip: 'Excluir Escola',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}