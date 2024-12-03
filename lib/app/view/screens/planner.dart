import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trabalho_final/app/view/screens/new_page.dart';
import '../state/my_app_state.dart';
import 'edit_new_page.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Certifique-se de importar o Firebase Auth

class PlannerPage extends StatelessWidget {
  const PlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    DateTime now = DateTime.now(); // Data atual
    DateTime firstDayOfCurrentWeek = now.subtract(Duration(days: now.weekday));

    User? user =
        FirebaseAuth.instance.currentUser; // Pega o usuário autenticado

    print('User UID: ${user?.uid}'); // Verifica o UID do usuário autenticado

    // Armazene o valor selecionado como uma cópia da data
    DateTime selectedDay = appState.selectedDay ?? now;

    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          height: 70,
          child: PageView.builder(
            itemBuilder: (context, pageIndex) {
              DateTime firstDayOfWeek =
                  firstDayOfCurrentWeek.add(Duration(days: pageIndex * 7));
              List<DateTime> days = List.generate(
                  7, (index) => firstDayOfWeek.add(Duration(days: index)));

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: days.length,
                itemBuilder: (context, index) {
                  DateTime day = days[index];
                  bool isSelected = day.isAtSameMomentAs(selectedDay);
                  bool isToday = day.isAtSameMomentAs(now);

                  Color buttonColor = isSelected
                      ? const Color(0xffbf567d)
                      : (isToday
                          ? const Color(0xffae114b)
                          : const Color(0xffd98baf));

                  return GestureDetector(
                    onTap: () {
                      context.read<MyAppState>().selectDay(day);
                    },
                    child: Container(
                      width: 45,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${day.day}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            Text(DateFormat('EEE').format(day),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 20), // Espaçamento entre os containers
        Expanded(
          child: user == null
              ? Center(
                  child: Text(
                    'Faça login e veja suas atividades do dia!',
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                )
              : StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('todos') // Coleção de tarefas no Firestore
                      .where('usuarioId',
                          isEqualTo: user?.uid) // Filtro pelo ID do usuário
                      .where('data',
                          isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(
                              selectedDay.year,
                              selectedDay.month,
                              selectedDay.day,
                              0,
                              0))) // Começo do dia
                      .where('data',
                          isLessThan: Timestamp.fromDate(DateTime(
                              selectedDay.year,
                              selectedDay.month,
                              selectedDay.day + 1,
                              0,
                              0))) // Começo do próximo dia
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      print("Esperando dados...");
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      print(
                          "Nenhuma tarefa encontrada para o dia $selectedDay");
                      return const Center(
                          child: Text('Nenhuma tarefa para hoje.'));
                    }

                    print("Tarefas encontradas: ${snapshot.data!.docs.length}");
                    return ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      children: snapshot.data!.docs
                          .map((data) => _buildTaskItem(context, data))
                          .toList(),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTaskItem(BuildContext context, DocumentSnapshot data) {
    final task = Task.fromSnapshot(data);
    final String corHex = task.cor ?? '0xfffeb3df';
    final Color cor = Color(int.parse(corHex));

    print(
        "Carregando tarefa: ${task.nome}"); // Print de depuração para cada tarefa

    return GestureDetector(
      onTap: () {
        final taskId = task.reference.id;

        if (taskId != null) {
          // Navegação para a página de edição
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  EditNewPage(
                      taskId: taskId), // Passando taskId para EditNewPage
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
        } else {
          // Se o taskId for nulo, exibe um erro
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erro: Tarefa não encontrada")),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cor, // Cor da tarefa obtida do banco
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          task.nome,
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xff302d2d),
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}

class Task {
  final String nome;
  final String? cor;
  final DocumentReference reference;

  Task.fromMap(Map<String, dynamic> map, {required this.reference})
      : assert(map['nome'] != null),
        nome = map['nome'],
        cor = map['cor'];

  Task.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data()! as Map<String, dynamic>,
            reference: snapshot.reference);

  @override
  String toString() => "Task<$nome, cor: $cor>";
}
