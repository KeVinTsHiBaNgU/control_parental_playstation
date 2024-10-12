import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'settings_screen.dart';

void main() {
  runApp(ControlParentalApp());
}

class ControlParentalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contrôle Parental PlayStation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String playStationStatus = 'Éteinte';

  Future<void> _turnOnPlayStation() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5000/turn_on'));
    if (response.statusCode == 200) {
      setState(() {
        playStationStatus = 'Allumée';
      });
    } else {
      // Gérer les erreurs
      setState(() {
        playStationStatus = 'Erreur lors de l\'allumage';
      });
    }
  }

  Future<void> _turnOffPlayStation() async {
    final response = await http.get(Uri.parse('http://10.192.53.247:5000/turn_off'));
    if (response.statusCode == 200) {
      setState(() {
        playStationStatus = 'Éteinte';
      });
    } else {
      // Gérer les erreurs
      setState(() {
        playStationStatus = 'Erreur lors de l\'extinction';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('État de la PlayStation'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('PlayStation $playStationStatus', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _turnOnPlayStation,
              child: Text('Allumer'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _turnOffPlayStation,
              child: Text('Éteindre'),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres de contrôle parental'),
      ),
      body: Center(
        child: Text('Configuration des limites de temps et autres paramètres'),
      ),
    );
  }
}
