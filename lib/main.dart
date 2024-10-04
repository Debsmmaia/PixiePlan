import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

//classe que defini o geral do app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Trabalho final',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Fredoka',
        ),
        home: const MyHomePage(title: 'PixiePlan'),
      ),
    );
  }
}

//classe da páigna inicial do app
class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    //cria a mudança de tela
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const LoginPage();
        break;
      case 1:
        page = const PlannerPage();
        break;
      default:
        page = const Center(child: Text('Página Não Encontrada'));
    }

    return LayoutBuilder(
      //cria widgets de forma dinâmica
      builder: (context, constraints) {
        return Scaffold(
          //fornece estrutura básica
          drawer: Drawer(
            //barra de navegaçaõ sanduiche
            width: 200,
            child: Column(
              children: [
                ListTile(
                  //lista com os ícones
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  leading: const Icon(Icons.person, color: Color(0xffd98baf)),
                  title: const Text(
                    'Perfil',
                    style: TextStyle(
                      color: Color(0xffbf567d),
                      fontSize: 20,
                    ),
                  ),
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
                  title: const Text(
                    'Meu Planner',
                    style: TextStyle(
                      color: Color(0xffbf567d),
                      fontSize: 20,
                    ),
                  ),
                  onTap: () {
                    //ao clicar muda a página
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
            //barra acima com a logo
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
            //botão de adicionar uma nova página
            onPressed: () {
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
            backgroundColor: const Color(0xffbf567d),
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            child: const Icon(Icons.add), // Ícone de "Adicionar"
          ),
        );
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _obscureText = true; // Controla a visibilidade da senha

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: ListView(
        children: <Widget>[
          Center(
            // Alinha o Container no centro da tela
            child: Container(
              width: 300, // Defina a largura desejada do Container
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: _controllerUsername,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: "Usuário",
                      border: OutlineInputBorder(),
                    ),
                    maxLength: 30,
                  ),
                  SizedBox(height: 20), // Espaçamento entre os campos
                  TextFormField(
                    controller: _controllerPassword,
                    style: TextStyle(fontSize: 20),
                    obscureText:
                        _obscureText, // Controla se a senha é visível ou não
                    decoration: InputDecoration(
                      hintText: "Senha",
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const ProfilePage(),
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
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlannerPage extends StatelessWidget {
  const PlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    DateTime now = DateTime.now(); // Data atual

    // Criação de uma lista com todos os dias do ano
    List<DateTime> days = [];
    DateTime startDate = DateTime(2024, 1, 1); // Data inicial
    DateTime endDate = DateTime(2100, 12, 31); // Data final

    for (DateTime date = startDate;
        date.isBefore(endDate.add(Duration(days: 1)));
        date = date.add(Duration(days: 1))) {
      days.add(date);
    }

    // Configuração para a visualização de dias
    int itemsPerPage = 7; // Número de dias exibidos por página
    int totalPages =
        (days.length / itemsPerPage).ceil(); // Número total de páginas

    return Column(
      children: [
        Center(
          child: Text(
            '${DateFormat('dd/MM/yyyy').format(appState.selectedDay)}',
            style: TextStyle(fontSize: 20, color: Color(0xffbf567d)),
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 70,
          child: PageView.builder(
            itemCount: totalPages, // Número total de páginas
            itemBuilder: (context, pageIndex) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: itemsPerPage, // Mostra 7 dias por vez
                itemBuilder: (context, index) {
                  int dayIndex = pageIndex * itemsPerPage +
                      index; // Calcula o índice do dia
                  if (dayIndex >= days.length)
                    return SizedBox
                        .shrink(); // Evita erro de índice fora do alcance

                  DateTime day = days[dayIndex];

                  // Verifica se o dia é o selecionado
                  final plannerState = context.watch<MyAppState>();
                  bool isSelected =
                      day.isAtSameMomentAs(plannerState.selectedDay);
                  bool isToday =
                      day.isAtSameMomentAs(now); // Verifica se é hoje

                  // Define a cor do botão
                  Color buttonColor = isSelected
                      ? Color(0xffbf567d)
                      : (isToday ? Color(0xffbf567d) : Color(0xffd98baf));

                  return GestureDetector(
                    onTap: () {
                      context
                          .read<MyAppState>()
                          .selectDay(day); // Atualiza o dia selecionado
                    },
                    child: Container(
                      width: 45,
                      margin: EdgeInsets.symmetric(horizontal: 3),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${day.day}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              DateFormat('EEE').format(day),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
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
      ],
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final String username = "Nome do Usuário";

    return Scaffold(
      body: Container(
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

            // Adicione mais informações ou widgets conforme necessário
            ElevatedButton(
              onPressed: () {
                // Ação para editar perfil ou outras funcionalidades
              },
              child: const Text('Editar Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  DateTime _selectedDay;

  MyAppState() : _selectedDay = DateTime.now() {
    print(
        "Dia inicial selecionado: $_selectedDay"); // Adicione esta linha para depuração
    notifyListeners(); // Notifica os ouvintes que o valor inicial foi definido
  }

  DateTime get selectedDay => _selectedDay;

  void selectDay(DateTime day) {
    _selectedDay = day;
    print("$_selectedDay"); // Adicione esta linha
    notifyListeners(); // Notifica os ouvintes que o dia foi alterado
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

            Container(
              width: 400,
              child: Center(
                child: TextFormField(
                  controller: _controller,
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "Nome da tarefa",
                    border: InputBorder.none,
                  ),
                ),
              ),
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
                  TextFormField(
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
