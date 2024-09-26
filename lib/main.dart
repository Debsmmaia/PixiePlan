import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Hello World',
      theme: ThemeData(
        primaryColor: Color(0xFFFFB2C1), // Rosa Claro
        scaffoldBackgroundColor: Colors.white, // Fundo Branco
      ),
      home: const MyHomePage(title: 'Planner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 1; // Inicializa com a página "Meu Planner"

  @override
  Widget build(BuildContext context) {
    // Determina a página a ser exibida com base no índice selecionado
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const ProfilePage();
        break;
      case 1:
        page = const PlannerPage(); // Página inicial como "Meu Planner"
        break;
      default:
        page = const Center(child: Text('Página Não Encontrada'));
    }

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Meu Planner'),
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: page,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navega para a nova página quando o botão é pressionado
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NewPage()),
          );
        },
        child: const Icon(Icons.add), // Ícone de "Adicionar"
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Página de Perfil',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class PlannerPage extends StatelessWidget {
  const PlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now(); // Data atual
    int daysInMonth =
        DateTime(now.year, now.month + 1, 0).day; // Total de dias no mês
    List<DateTime> days = List.generate(daysInMonth, (index) {
      return DateTime(now.year, now.month, index + 1); // Gera os dias do mês
    });

    // Encontra o índice do dia atual
    int todayIndex = days.indexWhere((day) =>
        day.day == now.day && day.month == now.month && day.year == now.year);

    return Column(
      children: [
        Center(
          child: Text(
            DateFormat('MMMM yyyy').format(now), // Mês e ano atual
            style: TextStyle(fontSize: 24),
          ),
        ),
        SizedBox(height: 20), // Espaçamento
        Container(
          height: 80, // Altura do ListView horizontal
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // Rolagem horizontal
            itemCount: days.length, // Número de dias
            controller: ScrollController(
                initialScrollOffset:
                    todayIndex * 75.0), // Ajusta a rolagem para o dia atual
            itemBuilder: (context, index) {
              DateTime day = days[index];
              bool isToday = day.day == now.day &&
                  day.month == now.month &&
                  day.year == now.year;

              return GestureDetector(
                onTap: () {
                  // Ação ao clicar no dia
                  print(
                      'Dia ${day.day} de ${DateFormat('MMMM').format(day)} selecionado');
                },
                child: Container(
                  width: 70,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color:
                        isToday ? Color(0xffe82d6b) : Colors.pink, // Cor do dia
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}', // Mostra o dia
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Nova página que aparece quando o botão flutuante é pressionado
class NewPage extends StatelessWidget {
  const NewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova tarefa'),
      ),
      body: Center(
        child: Text(
          'Adicionar tarefa',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
