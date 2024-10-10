import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../state/my_app_state.dart';
import 'edit_new_page.dart';

class PlannerPage extends StatelessWidget {
  const PlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    DateTime now = DateTime.now(); // Data atual

    // Lista de dias do ano
    List<DateTime> days = [];
    DateTime startDate = DateTime(2024, 1, 1);
    DateTime endDate = DateTime(2100, 12, 31);

    for (DateTime date = startDate;
        date.isBefore(endDate.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      days.add(date);
    }

    int itemsPerPage = 7;
    int totalPages = (days.length / itemsPerPage).ceil();

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
            itemCount: totalPages,
            itemBuilder: (context, pageIndex) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: itemsPerPage,
                itemBuilder: (context, index) {
                  int dayIndex = pageIndex * itemsPerPage + index;
                  if (dayIndex >= days.length) return const SizedBox.shrink();

                  DateTime day = days[dayIndex];
                  final plannerState = context.watch<MyAppState>();
                  bool isSelected =
                      day.isAtSameMomentAs(plannerState.selectedDay);
                  bool isToday = day.isAtSameMomentAs(now);

                  Color buttonColor = isSelected
                      ? const Color(0xffbf567d)
                      : (isToday
                          ? const Color(0xffbf567d)
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
        Padding(padding: const EdgeInsets.all(20)),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const EditNewPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin =
                      Offset(0.0, 1.0); // Inicia fora da tela, embaixo
                  const end = Offset.zero; // Fim no centro da tela
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
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xfffeb3df),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              'Nome da tarefa',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xff302d2d),
              ),
              textAlign: TextAlign.left,
            ),
          ),
        )
      ],
    );
  }
}
