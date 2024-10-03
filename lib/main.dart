import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifier(
      create: (context) => MyAppState(),
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
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                height: 50,
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: page,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navegar para a página de nova tarefa com a transição personalizada
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const NewPage(),
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
          backgroundColor: Color(0xffbf567d),
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          child: const Icon(Icons.add), // Ícone de "Adicionar"
        ));
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text("Faça login!"),
          ),
        ),
      ],
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

    // Cria o ScrollController e define a posição inicial
    final ScrollController scrollController = ScrollController(
      initialScrollOffset:
          todayIndex * 75.0, // Deslocamento inicial baseado no dia
    );

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
            controller: scrollController, // Vincula o ScrollController
            scrollDirection: Axis.horizontal, // Rolagem horizontal
            itemCount: days.length, // Número de dias
            itemBuilder: (context, index) {
              DateTime day = days[index];
              bool isToday = day.day == now.day &&
                  day.month == now.month &&
                  day.year == now.year;

              return GestureDetector(
                onTap: () {
                  // Modificar a página home ou qualquer outra ação ao tocar no dia
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
class NewPage extends StatefulWidget {
  const NewPage({super.key});

  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  DateTime? selectedDate;
  Color selectedColor = Color(0xfffeb3df); // Cor padrão

  // Método para selecionar a data
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Lista de cores para as bolinhas
  final List<Color> colors = [
    Color(0xfffeb3df),
    Color(0xffa3e8a5),
    Color(0xff97bddc),
    Color(0xffede493),
    Color(0xffce9bd7),
  ];

  @override
  Widget build(BuildContext context) {
    var _controller = TextEditingController();

    return Scaffold(
      body: Container(
        color: selectedColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.close, color: Color(0xff383636), size: 30),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(height: 35),

            TextFormField(
              controller: _controller,
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Nome da tarefa",
                border: InputBorder.none,
              ),
              onSaved: (String? val) {},
            ),

            Padding(padding: const EdgeInsets.all(20)),

            // Seção para escolher a cor
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: colors.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = color; // Atualiza a cor selecionada
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                        border: selectedColor == color
                            ? Border.all(color: Colors.white, width: 2)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),

            // Campo para selecionar a data
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Data da tarefa', style: TextStyle(fontSize: 22)),
                  SizedBox(height: 10),
                  TextField(
                    onTap: () {
                      _selectDate(context);
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: selectedDate != null
                          ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                          : 'Selecione uma data',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ],
              ),
            ),

            Padding(padding: const EdgeInsets.all(10)),

            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Criar tarefa"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  int selectedIndex = 1; // Página inicial

  // Mapa para armazenar atividades por data
  final Map<DateTime, List<String>> activities = {};

  // Atualiza o índice da página
  void updateSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  // Adiciona uma atividade para uma data específica
  void addActivity(DateTime date, String activity) {
    if (!activities.containsKey(date)) {
      activities[date] = [];
    }
    activities[date]!.add(activity);
    notifyListeners();
  }

  // Obtém as atividades de uma data específica
  List<String> getActivities(DateTime date) {
    return activities[date] ?? [];
  }
}
