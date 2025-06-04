import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_map_app/models/school.dart';
import 'package:school_map_app/providers/school_provider.dart';
import 'package:geolocator/geolocator.dart'; // Para obter a localização atual

class SchoolDetailScreen extends StatefulWidget {
  static const routeName = '/school-detail';
  const SchoolDetailScreen({super.key});

  @override
  State<SchoolDetailScreen> createState() => _SchoolDetailScreenState();
}

class _SchoolDetailScreenState extends State<SchoolDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _studentsController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  School? _editedSchool;
  bool _isEditing = false;
  bool _isLoadingLocation = false;
  bool _isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isEditing) {
      final schoolId = ModalRoute.of(context)?.settings.arguments as String?;
      if (schoolId != null) {
        _isEditing = true;
        _editedSchool = Provider.of<SchoolProvider>(context, listen: false)
            .schools
            .firstWhere((school) => school.id == schoolId);

        _nameController.text = _editedSchool!.name;
        _addressController.text = _editedSchool!.address;
        _studentsController.text = _editedSchool!.numberOfStudents.toString();
        _latitudeController.text = _editedSchool!.latitude.toString();
        _longitudeController.text = _editedSchool!.longitude.toString();
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissões negadas, mostrar mensagem ao usuário
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Permissão de localização negada.')),
            );
          }
          setState(() {
            _isLoadingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissões negadas permanentemente
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permissão de localização negada permanentemente. Habilite nas configurações do app.')),
          );
        }
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _latitudeController.text = position.latitude.toString();
        _longitudeController.text = position.longitude.toString();
      });
    } catch (e) {
      print('Erro ao obter localização: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao obter localização: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      _isSaving = true;
    });

    final newSchool = School(
      id: _isEditing ? _editedSchool!.id : null,
      name: _nameController.text,
      address: _addressController.text,
      numberOfStudents: int.parse(_studentsController.text),
      latitude: double.parse(_latitudeController.text),
      longitude: double.parse(_longitudeController.text),
    );

    final schoolProvider = Provider.of<SchoolProvider>(context, listen: false);
    bool success;
    if (_isEditing) {
      success = await schoolProvider.updateSchool(newSchool);
    } else {
      success = await schoolProvider.addSchool(newSchool);
    }

    setState(() {
      _isSaving = false;
    });

    if (success) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Falha ao ${_isEditing ? 'atualizar' : 'adicionar'} escola: ${schoolProvider.errorMessage ?? 'Erro desconhecido'}'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _studentsController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Escola' : 'Adicionar Escola'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveForm,
            tooltip: 'Salvar Escola',
          ),
        ],
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nome da Escola',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o nome da escola.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Endereço',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o endereço.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _studentsController,
                      decoration: InputDecoration(
                        labelText: 'Número de Alunos',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o número de alunos.';
                        }
                        if (int.tryParse(value) == null || int.parse(value) <= 0) {
                          return 'Por favor, insira um número válido de alunos.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _latitudeController,
                            decoration: InputDecoration(
                              labelText: 'Latitude',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Insira a latitude.';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Latitude inválida.';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _longitudeController,
                            decoration: InputDecoration(
                              labelText: 'Longitude',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Insira a longitude.';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Longitude inválida.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _isLoadingLocation
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton.icon(
                            onPressed: _getCurrentLocation,
                            icon: const Icon(Icons.location_on),
                            label: const Text('Obter Localização Atual'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}