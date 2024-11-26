import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trabalho_final/app/core/theme.dart';

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
