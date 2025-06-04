import 'package:flutter/material.dart';
import 'package:school_map_app/models/school.dart';
import 'package:school_map_app/services/api_service.dart';

class SchoolProvider with ChangeNotifier {
  final ApiService _apiService;
  List<School> _schools = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<School> get schools => _schools;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  SchoolProvider(this._apiService);

  // Busca todas as escolas
  Future<void> fetchSchools() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _schools = await _apiService.getSchools();
    } catch (e) {
      _errorMessage = 'Falha ao carregar escolas: $e';
      print('Erro em fetchSchools: $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Adiciona uma nova escola
  Future<bool> addSchool(School school) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final newSchool = await _apiService.addSchool(school);
      if (newSchool != null) {
        _schools.add(newSchool);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Falha ao adicionar escola: $e';
      print('Erro em addSchool: $_errorMessage');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Atualiza uma escola existente
  Future<bool> updateSchool(School school) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final updatedSchool = await _apiService.updateSchool(school);
      if (updatedSchool != null) {
        final index = _schools.indexWhere((s) => s.id == updatedSchool.id);
        if (index != -1) {
          _schools[index] = updatedSchool;
        }
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Falha ao atualizar escola: $e';
      print('Erro em updateSchool: $_errorMessage');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Exclui uma escola
  Future<bool> deleteSchool(String schoolId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final success = await _apiService.deleteSchool(schoolId);
      if (success) {
        _schools.removeWhere((school) => school.id == schoolId);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Falha ao excluir escola: $e';
      print('Erro em deleteSchool: $_errorMessage');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}