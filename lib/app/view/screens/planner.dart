import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trabalho_final/app/view/screens/new_page.dart';
import '../state/my_app_state.dart';
import 'edit_new_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlannerPage extends StatelessWidget {
  const PlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final DateTime now = DateTime.now();
    final DateTime firstDayOfCurrentWeek =
        now.subtract(Duration(days: now.weekday));
    final User? user = FirebaseAuth.instance.currentUser;
    final DateTime selectedDay = appState.selectedDay ?? now;

    void printDebugInfo() {
      print("Data selecionada: $selectedDay");
      print(
          "Início do dia: ${DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 0, 0)}");
      print(
          "Fim do dia: ${DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 23, 59, 59)}");
    }

    printDebugInfo();

    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          height: 70,
          child: PageView.builder(
            itemBuilder: (context, pageIndex) {
              final DateTime firstDayOfWeek =
                  firstDayOfCurrentWeek.add(Duration(days: pageIndex * 7));
              final List<DateTime> days = List.generate(
                7,
                (index) => firstDayOfWeek.add(Duration(days: index)),
              );

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final DateTime day = days[index];
                  final bool isSelected = day.isAtSameMomentAs(selectedDay);
                  final bool isToday = day.isAtSameMomentAs(now);
                  final Color buttonColor = isSelected
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
        const SizedBox(height: 20),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('todos')
                .where('data',
                    isGreaterThanOrEqualTo: Timestamp.fromDate(
                      DateTime(selectedDay.year, selectedDay.month,
                          selectedDay.day, 0, 0),
                    ))
                .where('data',
                    isLessThan: Timestamp.fromDate(
                      DateTime(selectedDay.year, selectedDay.month,
                          selectedDay.day, 23, 59, 59),
                    ))
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('Nenhuma tarefa para hoje.'),
                );
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
    final task = Task.fromSnapshot(data);
    final String corHex = task.cor ?? '0xfffeb3df';
    final Color cor = Color(int.parse(corHex));

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                EditNewPage(taskId: task.reference.id),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;
              final tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              final offsetAnimation = animation.drive(tween);

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
          color: cor,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              task.nome,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white, // Cor da fonte alterada para branca
              ),
              textAlign: TextAlign.left,
            ),
            Checkbox(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              value: task.status,
              onChanged: (bool? value) {
                if (value != null) {
                  task.reference.update({'status': value});
                }
              },
              activeColor: Colors.white,
              checkColor: Color(0xffd98baf),
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  final String nome;
  final String? cor;
  final bool status;
  final DocumentReference reference;

  Task.fromMap(Map<String, dynamic> map, {required this.reference})
      : assert(map['nome'] != null),
        nome = map['nome'],
        cor = map['cor'],
        status = map['status'];

  Task.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data()! as Map<String, dynamic>,
            reference: snapshot.reference);

  @override
  String toString() => "Task<$nome, cor: $cor, status: $status>";
}
