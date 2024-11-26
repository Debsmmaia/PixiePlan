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
  Color selectedColor = const Color(0xfffeb3df);
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
    const Color(0xfffeb3df),
    const Color(0xffa3e8a5),
    const Color(0xff97bddc),
    const Color(0xffede493),
    const Color(0xffce9bd7),
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
                  style: const TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: "Nome da tarefa",
                    border: InputBorder.none,
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
                  const Text('Data da tarefa', style: TextStyle(fontSize: 22)),
                  const SizedBox(height: 10),
                  TextFormField(
                    onTap: () {
                      _selectDate(context);
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: selectedDate != null
                          ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                          : 'Selecione uma data',
                      suffixIcon: const Icon(Icons.calendar_today),
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
