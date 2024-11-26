import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../state/my_app_state.dart';
import 'edit_new_page.dart';

class PlannerPage extends StatelessWidget {
  const PlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    DateTime now = DateTime.now(); // Data atual

    DateTime firstDayOfCurrentWeek = now.subtract(Duration(days: now.weekday));

    return Column(
      children: [
        Center(
          child: Text(
            '${DateFormat('dd/MM/yyyy').format(appState.selectedDay)}',
            style: const TextStyle(fontSize: 20, color: Color(0xffbf567d)),
          ),
        ),
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
                  bool isSelected = day.isAtSameMomentAs(appState.selectedDay);
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
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('todos') // Coleção de tarefas no Firestore
                .where('data',
                    isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(
                        appState.selectedDay.year,
                        appState.selectedDay.month,
                        appState.selectedDay.day,
                        0,
                        0)))
                .where('data',
                    isLessThan: Timestamp.fromDate(DateTime(
                        appState.selectedDay.year,
                        appState.selectedDay.month,
                        appState.selectedDay.day + 1,
                        0,
                        0)))
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              // Verifica se existem tarefas para o dia selecionado
              if (snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('Nenhuma tarefa para hoje.'));
              }

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
    // Converte os dados do snapshot para um objeto Task
    final task = Task.fromSnapshot(data);

    // Obtem a cor do Firestore, com fallback para uma cor padrão
    final String corHex =
        task.cor ?? '0xfffeb3df'; // Cor padrão se não houver no banco
    final Color cor = Color(int.parse(corHex)); // Converte para objeto Color

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const EditNewPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
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
