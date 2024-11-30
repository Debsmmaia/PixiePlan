import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trabalho_final/app/model/todo_model.dart';
import 'package:trabalho_final/app/service/firestore_service.dart';
import 'package:uuid/uuid.dart'; // Para gerar IDs únicos

class NewPage extends StatefulWidget {
  const NewPage({super.key});

  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  DateTime? selectedDate;
  Color selectedColor = const Color(0xffd98baf);
  final _controller = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

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
    const Color(0xffd98baf),
    const Color(0xff4a4a4a),
    const Color(0xff6c8eeb),
    const Color(0xffa78bc9),
    const Color(0xffe1a0a0),
  ];

  Future<void> _createTask() async {
    if (_controller.text.isEmpty || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    final id = const Uuid().v4();
    final newTask = TodoModel(
      id: id,
      nome: _controller.text,
      data: selectedDate!,
      cor: selectedColor.value.toString(),
    );

    try {
      await _firestoreService.addTodo(newTask);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarefa criada com sucesso!')),
      );
      Navigator.pop(context); // Voltar para a tela anterior
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar tarefa: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: selectedColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.close, color: Color(0xff383636), size: 30),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 35),
            SizedBox(
              width: 400,
              child: Center(
                child: TextFormField(
                  controller: _controller,
                  style: const TextStyle(
                    fontSize: 30, // Tamanho da fonte
                    color: Colors.white, // Cor do texto (branca)
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "Nome da tarefa",
                    hintStyle: const TextStyle(
                      color: Colors
                          .white70, // Cor do texto da dica (com 70% de opacidade)
                    ),
                    border: InputBorder.none, // Sem borda
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(20)),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: colors.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = color;
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Data da tarefa',
                      style: TextStyle(fontSize: 22, color: Colors.white)),
                  const SizedBox(height: 10),
                  TextFormField(
                    onTap: () {
                      _selectDate(context);
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white), // Borda branca
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Colors.white), // Borda branca quando habilitado
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white), // Borda branca quando focado
                      ),
                      hintText: selectedDate != null
                          ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                          : 'Selecione uma data',
                      suffixIcon: const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      ),
                      hintStyle: const TextStyle(
                          color: Colors.white), // Cor do texto do hint

                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Center(
              child: ElevatedButton(
                onPressed: _createTask,
                child: const Text("Criar tarefa"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
