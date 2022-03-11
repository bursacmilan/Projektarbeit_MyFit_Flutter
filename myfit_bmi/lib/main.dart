import 'package:flutter/material.dart';
import 'package:myfit_bmi/bmiHistory/bmi_history.dart';
import 'package:myfit_bmi/services/persistence_service.dart';
import 'bmiHistory/bmi_input.dart';

void main() {
  runApp(const Entrypoint());
}

class Entrypoint extends StatelessWidget {
  const Entrypoint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: MainScreen(title: 'MyFit BMI Rechner')
      )
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getWidgetForCurrentIndex() {
    if (_selectedIndex == 0) {
      return const BmiInputWidget();
    }

    return const BmiHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await PersistenceService.instance.deleteLast();
              _onItemTapped(0);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _getWidgetForCurrentIndex(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          )
        ],
      ),
    );
  }
}
