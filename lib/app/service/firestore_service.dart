import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trabalho_final/app/model/todo_model.dart';
import 'package:trabalho_final/app/view/screens/login.dart';

class FirestoreService {
  var firestore = FirebaseFirestore.instance;
  var firebaseAuth = FirebaseAuth.instance;

  Future<String> addTodo(TodoModel model) async {
    try {
      // Obtendo o usuário autenticado
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("Usuário não autenticado");
      }

      // Adicionando o 'usuarioId' ao modelo da tarefa
      model.usuarioId = user.uid;

      // Salvando a tarefa no Firestore com o ID do usuário
      var snapshot = await FirebaseFirestore.instance
          .collection('todos')
          .add(model.toMap());

      // Atribuindo o ID gerado pelo Firestore ao modelo
      model.id = snapshot.id;

      return snapshot.id;
    } on FirebaseException catch (e) {
      debugPrint("Failed with error '${e.code}': ${e.message}");
      throw Exception(e.message);
    }
  }

  Future<List<TodoModel>> getUserTodos() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return []; // Se o usuário não estiver autenticado, retorna uma lista vazia
    }

    try {
      // Debug: Verificando o ID do usuário atual
      debugPrint("Buscando tarefas para o usuário: ${user.uid}");

      // Consulta para obter as tarefas associadas ao usuário
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('todos')
          .where('usuarioId', isEqualTo: user.uid) // Filtra pelo ID do usuário
          .get();

      // Debug: Verificando o número de tarefas retornadas
      debugPrint("Número de tarefas encontradas: ${snapshot.docs.length}");

      // Converte cada documento para o modelo TodoModel
      return snapshot.docs
          .map((doc) =>
              TodoModel.fromFirestore(doc)) // Passa o doc para o fromFirestore
          .toList();
    } catch (e) {
      debugPrint("Erro ao buscar tarefas: $e");
      throw Exception("Erro ao buscar tarefas");
    }
  }

  Future<void> updateTodo(String id, TodoModel t) async {
    try {
      var snapshot = firestore.collection('todos').doc(id);
      await snapshot.update({
        'updateAt': FieldValue.serverTimestamp(), // Atualiza o campo 'updateAt'
      });
    } on FirebaseException catch (e) {
      debugPrint("Failed with error '${e.code}': ${e.message}");
      throw Exception(e.message);
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      final snapshot = firestore.collection('todos').doc(id);
      return await snapshot.delete();
    } on FirebaseException catch (e) {
      debugPrint("Failed with error '${e.code}': ${e.message}");
      throw Exception(e.message);
    }
  }

  Future<void> deleteAllData() async {
    try {
      final snapshot = await firestore.collection('todos').get();
      final List<DocumentSnapshot> docs = snapshot.docs;
      for (DocumentSnapshot doc in docs) {
        await doc.reference.delete();
      }
    } on FirebaseException catch (e) {
      debugPrint("Failed with error '${e.code}': ${e.message}");
      throw Exception(e.message);
    }
  }

  Future<bool> edit(TodoModel todoModel) async {
    try {
      final snapshot = firestore.collection('todos').doc(todoModel.id);

      // Atualizando o documento com as novas informações do TodoModel
      await snapshot.set(
        todoModel.toMap(),
        SetOptions(
            merge:
                true), // A opção 'merge' vai garantir que o documento seja atualizado sem sobrescrever tudo
      );
    } catch (e) {
      debugPrint("Erro ao editar a tarefa: $e");
      return false;
    }
    return true;
  }

  Future<UserCredential> criarUsuario(
      String email, String senha, String nome) async {
    // Tente criar o usuário no Firebase
    UserCredential userCred = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: senha);

    // Obter o ID do usuário
    String userId = userCred.user?.uid ?? '';

    // Se o ID do usuário estiver vazio, então algo deu errado
    if (userId.isEmpty) {
      throw Exception('Erro ao obter ID do usuário');
    }

    // Salve as informações do usuário no Firestore
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'nome': nome,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Faça login do usuário imediatamente após a criação
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: senha);

    return userCred;
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
