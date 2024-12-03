import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String? id;
  String? usuarioId; // Associado ao ID do usuário
  final String? nome;
  final bool status;
  final DateTime? data;
  final String? cor; // Cor armazenada em formato hexadecimal

  TodoModel({
    this.id,
    this.usuarioId,
    this.nome,
    this.status = false,
    this.data,
    this.cor,
  });

  // Construtor Factory para converter JSON em objeto Dart
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    try {
      return TodoModel(
        id: json['id'],
        usuarioId: json['usuarioId'], // Adicionando o campo usuarioId
        nome: json['nome'],
        status: json['status'] ?? false,
        data: json['data'] != null
            ? (json['data'] as Timestamp).toDate()
            : null, // Converte de Timestamp para DateTime
        cor: json['cor'], // Converte string hexadecimal para o campo cor
      );
    } catch (e) {
      throw Exception("Erro ao converter JSON para TodoModel: $e");
    }
  }

  // Método para converter objeto Dart em um Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuarioId': usuarioId, // Inclui o usuarioId no mapa
      'nome': nome,
      'status': status,
      'data': data != null
          ? Timestamp.fromDate(data!) // Converte DateTime para Timestamp
          : null,
      'cor': cor, // Salva a cor no formato hexadecimal
    };
  }

  TodoModel copyWith({
    String? id,
    String? usuarioId,
    String? nome,
    bool? status,
    DateTime? data,
    String? cor,
  }) {
    return TodoModel(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      nome: nome ?? this.nome,
      status: status ?? this.status,
      data: data ?? this.data,
      cor: cor ?? this.cor,
    );
  }

  // Construtor para converter do Firestore para TodoModel
  factory TodoModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return TodoModel(
      id: data['id'],
      usuarioId: data['usuarioId'], // Lê o usuarioId
      nome: data['nome'],
      status: data['status'],
      data: (data['data'] as Timestamp?)?.toDate(), // Timestamp para DateTime
      cor: data['cor'],
    );
  }
}
