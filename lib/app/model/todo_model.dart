import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String? id;
  String? usuarioId;
  final String? nome;
  final bool status;
  final DateTime? data;
  final String? cor;

  TodoModel({
    this.id,
    this.usuarioId,
    this.nome,
    this.status = false,
    this.data,
    this.cor,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    try {
      return TodoModel(
        id: json['id'],
        usuarioId: json['usuarioId'],
        nome: json['nome'],
        status: json['status'] ?? false,
        data:
            json['data'] != null ? (json['data'] as Timestamp).toDate() : null,
        cor: json['cor'],
      );
    } catch (e) {
      throw Exception("Erro ao converter JSON para TodoModel: $e");
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'nome': nome,
      'status': status,
      'data': data != null ? Timestamp.fromDate(data!) : null,
      'cor': cor,
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

  factory TodoModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return TodoModel(
      id: data['id'],
      usuarioId: data['usuarioId'],
      nome: data['nome'],
      status: data['status'],
      data: (data['data'] as Timestamp?)?.toDate(),
      cor: data['cor'],
    );
  }
}
