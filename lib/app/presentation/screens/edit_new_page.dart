import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditNewPage extends StatefulWidget {
  const EditNewPage({super.key});

  @override
  _EditNewPageState createState() => _EditNewPageState();
}

class _EditNewPageState extends State<EditNewPage> {
  DateTime? selectedDate;
  Color selectedColor = Color(0xfffeb3df);
  final TextEditingController _controller =
      TextEditingController(); // Controlador inicializado

  @override
  void dispose() {
    _controller.dispose(); // Libera o controlador quando o widget for destruído
    super.dispose();
  }

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
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
            SizedBox(height: 20),
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
                onPressed: () {
                  String taskName = _controller.text;
                  if (taskName.isNotEmpty && selectedDate != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tarefa criada: $taskName')),
                    );
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Preencha todos os campos')),
                    );
                  }
                },
                child: Text("Editar tarefa"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
