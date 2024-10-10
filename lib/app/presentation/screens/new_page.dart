import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewPage extends StatefulWidget {
  const NewPage({super.key});

  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  DateTime? selectedDate;
  Color selectedColor = Color(0xfffeb3df);

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
