import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditNewPage extends StatefulWidget {
  final String taskId;

  const EditNewPage({super.key, required this.taskId});

  @override
  _EditNewPageState createState() => _EditNewPageState();
}

class _EditNewPageState extends State<EditNewPage> {
  DateTime? selectedDate;
  Color selectedColor = Color(0xfffeb3df);
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTaskData();
  }

  Future<void> _loadTaskData() async {
    try {
      // Buscar dados da tarefa no Firestore usando o taskId
      DocumentSnapshot taskSnapshot = await FirebaseFirestore.instance
          .collection('todos')
          .doc(widget.taskId) // Usando o taskId para buscar a tarefa
          .get();

      if (taskSnapshot.exists) {
        var taskData = taskSnapshot.data() as Map<String, dynamic>;
        _controller.text = taskData['nome'] ?? '';
        selectedDate = (taskData['data'] as Timestamp).toDate();
        selectedColor = Color(int.parse(taskData['cor'] ?? '0xfffeb3df'));
        setState(() {});
      }
    } catch (e) {
      // Lidar com erro ao carregar a tarefa
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao carregar a tarefa')));
    }
  }

  Future<void> _updateTask() async {
    if (_controller.text.isNotEmpty && selectedDate != null) {
      try {
        // Atualiza a tarefa no Firestore
        await FirebaseFirestore.instance
            .collection('todos')
            .doc(widget.taskId)
            .update({
          'nome': _controller.text,
          'data': Timestamp.fromDate(selectedDate!),
          'cor': selectedColor.value.toString(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tarefa atualizada com sucesso')));
        Navigator.of(context).pop(); // Voltar à página anterior
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao atualizar a tarefa')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Preencha todos os campos')));
    }
  }

  Future<void> _deleteTask() async {
    try {
      // Exclui a tarefa do Firestore
      await FirebaseFirestore.instance
          .collection('todos')
          .doc(widget.taskId)
          .delete();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Tarefa excluída com sucesso')));
      Navigator.of(context).pop(); // Voltar à página anterior
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao excluir a tarefa')));
    }
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
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white, // Cor branca para o texto
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "Nome da tarefa",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Data da tarefa',
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white)), // Texto da data em branco
                  SizedBox(height: 10),
                  TextFormField(
                    onTap: () {
                      _selectDate(context);
                    },
                    readOnly: true,
                    style: TextStyle(
                        color: Colors.white), // Texto da data em branco
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: selectedDate != null
                          ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                          : 'Selecione uma data',
                      suffixIcon: Icon(Icons.calendar_today,
                          color: Colors.white), // Ícone da data em branco
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Alinha os botões no centro
                children: [
                  // Botão "Editar Tarefa"
                  ElevatedButton(
                    onPressed: _updateTask,
                    child: Text("Editar tarefa"),
                  ),
                  const SizedBox(width: 10), // Espaçamento entre os botões
                  // Botão "Excluir Tarefa"
                  ElevatedButton(
                    onPressed: _deleteTask,
                    child: Text(
                      "Excluir Tarefa",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
