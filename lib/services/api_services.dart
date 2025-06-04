import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  
  static const String _baseUrl = 'http://192.168.1.100:8080';
  final String? _token;

  ApiService(this._token);

  // Constrói os cabeçalhos da requisição, incluindo o token de autenticação
  Map<String, String> _getHeaders({bool includeAuth = true}) {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    if (includeAuth && _token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  // Método para fazer login
  Future<String?> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/api/auth/login'); // Endpoint de autenticação
    try {
      final response = await http.post(
        url,
        headers: _getHeaders(includeAuth: false), // Não inclui token para login
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['token']; // Assumindo que o backend retorna um 'token'
      } else {
        print('Erro de login: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exceção ao fazer login: $e');
      return null;
    }
  }

  // Método para registrar um novo usuário (se o backend suportar)
  Future<bool> register(String email, String password) async {
    final url = Uri.parse('$_baseUrl/api/auth/register'); // Endpoint de registro
    try {
      final response = await http.post(
        url,
        headers: _getHeaders(includeAuth: false),
        body: json.encode({'email': email, 'password': password}),
      );
      return response.statusCode == 201; // 201 Created para sucesso no registro
    } catch (e) {
      print('Exceção ao registrar: $e');
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Métodos CRUD para Escolas (/api/schools)
  // ---------------------------------------------------------------------------

  // Obter todas as escolas
  Future<List<School>> getSchools() async {
    final url = Uri.parse('$_baseUrl/api/schools');
    try {
      final response = await http.get(url, headers: _getHeaders());
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => School.fromJson(json)).toList();
      } else {
        print('Erro ao buscar escolas: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Exceção ao buscar escolas: $e');
      return [];
    }
  }

  // Adicionar uma nova escola
  Future<School?> addSchool(School school) async {
    final url = Uri.parse('$_baseUrl/api/schools');
    try {
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: json.encode(school.toJson()),
      );
      if (response.statusCode == 201) { // 201 Created
        return School.fromJson(json.decode(response.body));
      } else {
        print('Erro ao adicionar escola: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exceção ao adicionar escola: $e');
      return null;
    }
  }

  // Atualizar uma escola existente
  Future<School?> updateSchool(School school) async {
    final url = Uri.parse('$_baseUrl/api/schools/${school.id}');
    try {
      final response = await http.put(
        url,
        headers: _getHeaders(),
        body: json.encode(school.toJson()),
      );
      if (response.statusCode == 200) {
        return School.fromJson(json.decode(response.body));
      } else {
        print('Erro ao atualizar escola: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exceção ao atualizar escola: $e');
      return null;
    }
  }

  // Excluir uma escola
  Future<bool> deleteSchool(String schoolId) async {
    final url = Uri.parse('$_baseUrl/api/schools/$schoolId');
    try {
      final response = await http.delete(url, headers: _getHeaders());
      return response.statusCode == 204; // 204 No Content para sucesso na exclusão
    } catch (e) {
      print('Exceção ao excluir escola: $e');
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Métodos para Feedback (/api/feedback)
  // ---------------------------------------------------------------------------

  // Enviar feedback
  Future<bool> submitFeedback(String schoolId, String feedbackText) async {
    final url = Uri.parse('$_baseUrl/api/feedback');
    try {
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: json.encode({'schoolId': schoolId, 'feedbackText': feedbackText}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Exceção ao enviar feedback: $e');
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Métodos para Relatórios (/api/reports)
  // ---------------------------------------------------------------------------

  // Obter dados de relatórios (exemplo)
  Future<Map<String, dynamic>?> getReportsData() async {
    final url = Uri.parse('$_baseUrl/api/reports/summary'); // Exemplo de endpoint
    try {
      final response = await http.get(url, headers: _getHeaders());
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Erro ao buscar relatórios: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exceção ao buscar relatórios: $e');
      return null;
    }
  }
}