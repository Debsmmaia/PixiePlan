import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trabalho final',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Fundo Branco
        fontFamily: 'Fredoka',
      ),
      home: const MyHomePage(title: 'PixiePlan'),
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
        width: 200,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: Color(0xffd98baf)),
              title: const Text('Perfil',
                  style: TextStyle(
                    color: Color(0xffbf567d),
                    fontSize: 20,
                  )),
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.book, color: Color(0xffd98baf)),
              title: const Text('Meu Planner',
                  style: TextStyle(
                    color: Color(0xffbf567d),
                    fontSize: 20,
                  )),
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/imagens/logo_pixie.png',
              fit: BoxFit.contain,
              height: 38,
            ),
            const SizedBox(width: 10), // Espaço entre logo e texto, opcional
          ],
        ),
        centerTitle: true,
      ),
      body: page,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Página de criação de tarefa
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NewPage()),
          );
        },
        backgroundColor: Color(0xffbf567d),
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
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
        style: TextStyle(
          fontSize: 24, // Corrigido aqui
        ),
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
            'Seja bem-vindo(a)!',
            style: TextStyle(fontSize: 20, color: Color(0xffbf567d)),
          ),
        ),
        SizedBox(height: 20), // Espaçamento
        Container(
          height: 60,
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
                  // modificar a página home
                },
                child: Container(
                  width: 50,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: isToday ? Color(0xffbf567d) : Color(0xffd98baf),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Centraliza o conteúdo
                      children: [
                        Text(
                          '${day.day}', // Mostra o dia
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17), // Estilo do dia
                        ),
                        Text(
                          DateFormat('MMM').format(
                              day), // Mostra o mês em formato abreviado (Jan, Feb...)
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12), // Estilo do mês
                        ),
                      ],
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
